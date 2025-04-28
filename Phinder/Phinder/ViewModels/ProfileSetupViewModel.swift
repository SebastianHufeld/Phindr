//
//  ProfileSetupViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 28.04.25.
//

import Foundation

@MainActor
class ProfileSetupViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var isPhotographer: Bool = false
    @Published var isModel: Bool = false
    @Published var isStudio: Bool = false
    @Published var streetName: String = ""
    @Published var houseNumber: Int?
    @Published var city: String = ""
    @Published var postalCode: Int?
    
    @Published var errorMessage: String?
    
    func validateProfileData() -> Bool {
        guard !streetName.isEmpty,
              houseNumber != nil,
              !city.isEmpty,
              postalCode != nil else {
            errorMessage = "Bitte alle Felder ausfüllen."
            return false
        }
        return true
    }
    
    func buildProfileData() -> ProfileData? {
        guard validateProfileData(),
              let houseNumber = houseNumber,
              let postalCode = postalCode else { return nil }
        
        return ProfileData(
            isPhotographer: isPhotographer,
            isModel: isModel,
            isStudio: isStudio,
            streetName: streetName,
            houseNumber: houseNumber,
            city: city,
            postalCode: postalCode
        )
    }
    func saveProfile(loginViewModel: LoginViewModel) {
        guard let registerData = loginViewModel.registerData else {
            self.errorMessage = "Fehler: Keine Registrierungsdaten vorhanden."
            return
        }
        
        guard let profileData = buildProfileData() else {
            return // Fehler ist schon gesetzt
        }
        
        loginViewModel.createPhinderUser(registerData: registerData, profileData: profileData)
    }
}
