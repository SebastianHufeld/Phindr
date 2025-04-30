import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class LoginViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isRegistrationInProgress = false
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    var isUserLoggedIn: Bool {
        self.user != nil
    }
    
    init() {
        self.checkLoginState()
    }
    
    func registerUser(email: String, username: String, password: String, passwordValidation: String, profileData: ProfileData) {
        guard email.contains("@") else {
            self.errorMessage = "Email-Adresse ungültig"
            return
        }
        
        guard password == passwordValidation else {
            self.errorMessage = "Passwörter stimmen nicht überein"
            return
        }
        
        self.isRegistrationInProgress = true
        self.errorMessage = nil
        
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                let firebaseAuthUserId = result.user.uid
                
            
                let newUser = User(
                    userId: firebaseAuthUserId,
                    username: username,
                    mail: email,
                    firstName: profileData.firstName,
                    lastName: profileData.lastName,
                    isPhotographer: profileData.isPhotographer,
                    isModel: profileData.isModel,
                    isStudio: profileData.isStudio,
                    streetName: profileData.streetName,
                    houseNumber: profileData.houseNumber,
                    city: profileData.city,
                    postalCode: profileData.postalCode,
                    registrationDate: Date()
                )
                
                try await firestore.collection("users").document(newUser.userId).setData(from: newUser)
                self.user = newUser
                self.isRegistrationInProgress = false
                
            } catch {
                self.errorMessage = "Registrierung fehlgeschlagen: \(error.localizedDescription)"
                self.isRegistrationInProgress = false
                print(error)
            }
        }
    }
    
    func loginUser(withEmail email: String, password: String) {
        self.errorMessage = nil
        
        Task {
            do {
                let result = try await auth.signIn(withEmail: email, password: password)
                let authUserId = result.user.uid
                self.readUser(userId: authUserId)
            } catch {
                errorMessage = "Login fehlgeschlagen: \(error.localizedDescription)"
                print(error)
            }
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
            self.user = nil
        } catch {
            errorMessage = "Abmelden fehlgeschlagen: \(error.localizedDescription)"
            print(error)
        }
    }
    
    private func readUser(userId: String) {
        Task {
            do {
                let document = try await firestore.collection("users").document(userId).getDocument()
                self.user = try document.data(as: User.self)
            } catch {
                errorMessage = "Benutzer lesen fehlgeschlagen: \(error.localizedDescription)"
                print(error)
            }
        }
    }
    
    private func checkLoginState() {
        if let currentUser = auth.currentUser {
            self.readUser(userId: currentUser.uid)
        }
    }
}
