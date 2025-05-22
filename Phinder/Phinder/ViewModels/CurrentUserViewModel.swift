//
//  CurrentUserViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 22.05.25.
//

// CurrentUserViewModel.swift
import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class CurrentUserViewModel: ObservableObject {
    @Published var user: User?

    private let firestoreDb = Firestore.firestore()

    init() {
        Task {
            await fetchCurrentUser()
        }
    }

    func fetchCurrentUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Kein eingeloggter User")
            return
        }

        do {
            let snapshot = try await firestoreDb.collection("users").document(uid).getDocument()
            self.user = try snapshot.data(as: User.self)
            print("User erfolgreich geladen: \(String(describing: self.user?.firstName))")
        } catch {
            print("Fehler beim Laden des Users: \(error)")
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Fehler beim Logout: \(error)")
        }
    }
}
