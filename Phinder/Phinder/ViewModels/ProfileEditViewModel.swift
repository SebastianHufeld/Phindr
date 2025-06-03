//
//  ProfileEditViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 15.05.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import PhotosUI
import CoreLocation

@MainActor
class ProfileEditViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var mail: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var gender: String = ""
    @Published var birthdate: Date = Date()
    @Published var isPhotographer: Bool = false
    @Published var isModel: Bool = false
    @Published var isStudio: Bool = false
    @Published var streetName: String = ""
    @Published var houseNumber: String = ""
    @Published var city: String = ""
    @Published var postalCode: String = ""
    @Published var experienceLevel: String = ""
    @Published var shootingCategories: [String] = []
    @Published var hasTattoos: Bool = false
    @Published var hasPiercings: Bool = false
    @Published var websiteURL: String = ""
    @Published var instagramURL: String = ""
    @Published var tiktokURL: String = ""
    @Published var contactMail: String = ""
    @Published var photoPickerItem: PhotosPickerItem?
    @Published var profileImage: Image?
    @Published var profileImageData: Data?
    @Published var profileImageURL: String?
    @Published var isUploadingImage = false
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var errorMessage: String?

    private let firestoreDb = Firestore.firestore()
    private let auth = Auth.auth()
    private var user: User?
    private let imgurRepository = ImgurAPIRepository()
    private let loginViewModel: LoginViewModel

    let genderOptions = ["Männlich", "Weiblich", "Divers"]
    let experienceLevelOptions = ["Anfänger", "Semiprofi", "Profi"]
    let availableShootingCategories = ["Portrait", "Lingerie", "Studio", "Teilakt", "Akt", "Bademode"]

    init(user: User?, loginViewModel: LoginViewModel) {
        self.user = user
        self.loginViewModel = loginViewModel
        loadUserData()
    }

    private func loadUserData() {
        guard let user = user else { return }
        username = user.username
        mail = user.mail
        firstName = user.firstName
        lastName = user.lastName
        gender = user.gender
        birthdate = user.birthdate
        isPhotographer = user.isPhotographer
        isModel = user.isModel
        isStudio = user.isStudio
        streetName = user.streetName
        houseNumber = user.houseNumber
        city = user.city
        postalCode = user.postalCode
        experienceLevel = user.experienceLevel
        shootingCategories = user.shootingCategories
        hasTattoos = user.hasTattoos
        hasPiercings = user.hasPiercings
        profileImageURL = user.profileImageURL

        if let imageURLString = user.profileImageURL, let imageURL = URL(string: imageURLString) {
            loadImageFromURL(imageURL)
        }
    }

    private func loadImageFromURL(_ url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    profileImage = Image(uiImage: uiImage)
                    profileImageData = data
                }
            } catch {
                print("Fehler beim Laden des Bildes: \(error)")
            }
        }
    }

    func loadSelectedImage() {
        Task {
            do {
                guard let item = photoPickerItem else { return }
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    errorMessage = "Bilddaten konnten nicht gelesen werden"
                    return
                }
                if let uiImage = UIImage(data: data) {
                    profileImage = Image(uiImage: uiImage)
                    profileImageData = data
                }
            } catch {
                errorMessage = "Fehler beim Laden des Bildes: \(error.localizedDescription)"
                print(error)
            }
        }
    }

    func uploadProfileImage() async -> Bool {
        guard let imageData = profileImageData else {
            errorMessage = "Kein Bild ausgewählt"
            return false
        }
        let compressedImageData: Data
        if imageData.count > 1_000_000 {
            if let uiImage = UIImage(data: imageData),
               let compressedData = uiImage.jpegData(compressionQuality: 0.5) {
                compressedImageData = compressedData
            } else {
                compressedImageData = imageData
            }
        } else {
            compressedImageData = imageData
        }

        isUploadingImage = true
        do {
            let response = try await imgurRepository.uploadImage(compressedImageData)
            profileImageURL = response.data.link.absoluteString
            if let userId = user?.userId {
                try await firestoreDb.collection("users").document(userId).updateData([
                    "profileImageURL": profileImageURL as Any
                ])
            }
            isUploadingImage = false
            return true
        } catch {
            isUploadingImage = false
            errorMessage = "Fehler beim Hochladen des Bildes: \(error.localizedDescription)"
            print(error)
            return false
        }
    }

    func saveProfile() async {
        guard validateProfileData() else {
            showAlert = true
            alertMessage = errorMessage ?? "Bitte überprüfe deine Eingaben."
            return
        }
        guard let userId = user?.userId else {
            errorMessage = "Benutzer-ID nicht gefunden"
            showAlert = true
            alertMessage = errorMessage ?? "Ein Fehler ist aufgetreten."
            return
        }
        isLoading = true
        errorMessage = nil
        if profileImageData != nil && (profileImageURL == nil || photoPickerItem != nil) {
            let success = await uploadProfileImage()
            if !success {
                isLoading = false
                showAlert = true
                alertMessage = errorMessage ?? "Fehler beim Hochladen des Bildes."
                return
            }
        }

        var userData: [String: Any] = [
            "username": username,
            "mail": mail,
            "firstName": firstName,
            "lastName": lastName,
            "gender": gender,
            "birthdate": birthdate,
            "isPhotographer": isPhotographer,
            "isModel": isModel,
            "isStudio": isStudio,
            "streetName": streetName,
            "houseNumber": houseNumber,
            "city": city,
            "postalCode": postalCode,
            "experienceLevel": experienceLevel,
            "shootingCategories": shootingCategories,
            "hasTattoos": hasTattoos,
            "hasPiercings": hasPiercings,
            "websiteURL": websiteURL,
            "instagramURL": instagramURL,
            "tiktokURL": tiktokURL,
            "contactMail": contactMail
        ]

        let fullAddress = "\(streetName) \(houseNumber), \(postalCode) \(city)"
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.geocodeAddressString(fullAddress)
            let coordinate = placemarks.first?.location?.coordinate
            userData["latitude"] = coordinate?.latitude
            userData["longitude"] = coordinate?.longitude
        } catch {
            print("Geocoding fehlgeschlagen: \(error.localizedDescription)")
        }

        if let imageURL = profileImageURL {
            userData["profileImageURL"] = imageURL
        }

        do {
            try await firestoreDb.collection("users").document(userId).updateData(userData)
            if let currentUser = auth.currentUser, currentUser.email != mail {
                try await currentUser.sendEmailVerification(beforeUpdatingEmail: mail)
            }
            let updatedUser = User(
                userId: userId,
                username: username,
                mail: mail,
                firstName: firstName,
                lastName: lastName,
                gender: gender,
                birthdate: birthdate,
                isPhotographer: isPhotographer,
                isModel: isModel,
                isStudio: isStudio,
                streetName: streetName,
                houseNumber: houseNumber,
                city: city,
                postalCode: postalCode,
                experienceLevel: experienceLevel,
                shootingCategories: shootingCategories,
                hasTattoos: hasTattoos,
                hasPiercings: hasPiercings,
                registrationDate: user?.registrationDate ?? Date(),
                profileImageURL: profileImageURL,
                websiteURL: websiteURL,
                instagramURL: instagramURL,
                tiktokURL: tiktokURL,
                contactEmail: contactMail,
                latitude: userData["latitude"] as? Double,
                longitude: userData["longitude"] as? Double
            )
            loginViewModel.user = updatedUser
            if let imageURL = profileImageURL {
                await loginViewModel.updateProfileImage(from: imageURL)
            }
            await loginViewModel.currentUserViewModel.fetchCurrentUser()
            showAlert = true
            alertMessage = "Profil erfolgreich aktualisiert!"
        } catch {
            errorMessage = "Fehler beim Speichern: \(error.localizedDescription)"
            showAlert = true
            alertMessage = errorMessage ?? "Ein Fehler ist aufgetreten."
            print(error)
        }
        isLoading = false
    }

    func validateProfileData() -> Bool {
        guard isPhotographer || isModel || isStudio else {
            errorMessage = "Bitte wähle mindestens eine Rolle aus."
            return false
        }
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !streetName.isEmpty,
              !houseNumber.isEmpty,
              !city.isEmpty,
              !postalCode.isEmpty else {
            errorMessage = "Bitte alle Pflichtfelder ausfüllen."
            return false
        }
        guard !gender.isEmpty else {
            errorMessage = "Bitte wähle ein Geschlecht aus."
            return false
        }
        guard !experienceLevel.isEmpty else {
            errorMessage = "Bitte wähle ein Erfahrungslevel aus."
            return false
        }
        guard !shootingCategories.isEmpty else {
            errorMessage = "Bitte wähle mindestens eine Shooting-Kategorie aus."
            return false
        }
        errorMessage = nil
        return true
    }

    func toggleCategory(_ category: String) {
        if shootingCategories.contains(category) {
            shootingCategories.removeAll { $0 == category }
        } else {
            shootingCategories.append(category)
        }
    }
}
