//
//  LoginViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 28.04.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isRegistrationInProgress = false
    @Published var profileImage: Image?

    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()

    var isUserLoggedIn: Bool {
        self.user != nil
    }

    init() {
        self.checkLoginState()
    }

    func registerUser(
        email: String,
        username: String,
        password: String,
        passwordValidation: String,
        profileData: ProfileData,
        searchFilter: FilterViewModel
    ) {
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
                let uid = result.user.uid

                let newUser = User(
                    userId: uid,
                    username: username,
                    mail: email,
                    firstName: profileData.firstName,
                    lastName: profileData.lastName,
                    gender: searchFilter.gender,
                    birthdate: searchFilter.birthdate,
                    isPhotographer: profileData.isPhotographer,
                    isModel: profileData.isModel,
                    isStudio: profileData.isStudio,
                    streetName: profileData.streetName,
                    houseNumber: profileData.houseNumber,
                    city: profileData.city,
                    postalCode: profileData.postalCode,
                    experienceLevel: searchFilter.experienceLevel,
                    shootingCategories: searchFilter.shootingCategories,
                    hasTattoos: searchFilter.hasTattoos,
                    hasPiercings: searchFilter.hasPiercings,
                    registrationDate: Date(),
                    profileImageURL: nil
                )

                try firestore.collection("users").document(uid).setData(from: newUser)
                self.user = newUser
                self.isRegistrationInProgress = false

            } catch {
                self.errorMessage = "Registrierung fehlgeschlagen: \(error.localizedDescription)"
                print(error)
            }
            self.isRegistrationInProgress = false
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
            self.profileImage = nil
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
                if let imageURLString = self.user?.profileImageURL, let imageURL = URL(string: imageURLString) {
                    await loadImage(from: imageURL)
                } else {
                    self.profileImage = nil
                }
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

    func validateRegistration(email: String, password: String, passwordValidation: String) -> Bool {
        if !email.contains("@") || !email.contains(".") {
            self.errorMessage = "Bitte gib eine gültige E-Mail-Adresse ein."
            return false
        }

        if password.count < 6 {
            self.errorMessage = "Das Passwort muss mindestens 6 Zeichen lang sein."
            return false
        }

        if password != passwordValidation {
            self.errorMessage = "Die Passwörter stimmen nicht überein."
            return false
        }

        self.errorMessage = nil
        return true
    }

    private func loadImage(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImage = nil
                }
            }
        } catch {
            print("Fehler beim Laden des Profilbildes: \(error)")
            DispatchQueue.main.async {
                self.profileImage = nil
            }
        }
    }
    func updateProfileImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
            }
        } catch {
            print("Fehler beim Laden des Profilbildes: \(error)")
        }
    }

}
