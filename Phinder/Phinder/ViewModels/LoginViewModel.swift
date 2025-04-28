//
//  LoginViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 28.04.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class LoginViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var registerData: RegisterData?

    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()

    var isUserLoggedIn: Bool {
        self.user != nil
    }

    init() {
        self.checkLoginState()
    }

    func registerUser(withEmail email: String, username: String, password: String, passwordValidation: String) {
        guard email.contains("@") else {
            self.errorMessage = "Email-Adresse ungültig"
            return
        }

        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                let firebaseAuthUserId = result.user.uid
                self.registerData = RegisterData(
                    userId: firebaseAuthUserId,
                    username: username,
                    email: email,
                    firstName: "",
                    lastName: ""
                )
            } catch {
                errorMessage = "Account konnte nicht angelegt werden: \(error.localizedDescription)"
                print(error)
            }
        }
    }


    func createPhinderUser(registerData: RegisterData, profileData: ProfileData) {
        let newUser = User(
            userId: registerData.userId,
            username: registerData.username,
            mail: registerData.email,
            firstName: registerData.firstName,
            lastName: registerData.lastName,
            isPhotographer: profileData.isPhotographer,
            isModel: profileData.isModel,
            isStudio: profileData.isStudio,
            streetName: profileData.streetName,
            houseNumber: profileData.houseNumber,
            city: profileData.city,
            postalCode: profileData.postalCode,
            registrationDate: Date()
        )

        Task {
            do {
                try firestore.collection("users").document(newUser.userId).setData(from: newUser)
                self.user = newUser
            } catch {
                self.errorMessage = "Nutzer konnte nicht erstellt werden: \(error.localizedDescription)"
                print(error)
            }
        }
    }

    func loginUser(withEmail email: String, password: String) {
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
