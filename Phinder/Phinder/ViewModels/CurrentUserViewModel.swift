//
//  CurrentUserViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 22.05.25.
//

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

    func updateDescriptionText(_ text: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            try await firestoreDb.collection("users").document(uid).updateData([
                "descriptionText": text
            ])
            user?.descriptionText = text
        } catch {
            print("Fehler beim Speichern von descriptionText: \(error)")
        }
    }

    func updateContactInfo(
        contactEmail: String?,
        websiteURL: String?,
        instagramURL: String?,
        tiktokURL: String?
    ) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        var updateData: [String: Any?] = [:]

        if let email = contactEmail, !email.isEmpty {
            updateData["contactEmail"] = email
        } else {
            updateData["contactEmail"] = NSNull()
        }

        if let website = websiteURL, !website.isEmpty {
            updateData["websiteURL"] = website
        } else {
            updateData["websiteURL"] = NSNull()
        }

        if let instagram = instagramURL, !instagram.isEmpty {
            updateData["instagramURL"] = instagram
        } else {
            updateData["instagramURL"] = NSNull()
        }

        if let tiktok = tiktokURL, !tiktok.isEmpty {
            updateData["tiktokURL"] = tiktok
        } else {
            updateData["tiktokURL"] = NSNull()
        }

        do {
            try await firestoreDb.collection("users").document(uid).updateData(updateData as [String : Any])

            user?.contactEmail = contactEmail
            user?.websiteURL = websiteURL
            user?.instagramURL = instagramURL
            user?.tiktokURL = tiktokURL

            print("Kontaktdaten erfolgreich gespeichert!")
        } catch {
            print("Fehler beim Speichern der Kontaktdaten: \(error)")
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
