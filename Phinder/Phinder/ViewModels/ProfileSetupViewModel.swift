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
    @Published var houseNumber: String = ""
    @Published var city: String = ""
    @Published var postalCode: String = ""
    
    @Published var errorMessage: String?
    
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
            errorMessage = "Bitte alle Felder ausfüllen."
            return false
        }
        
        return true
    }
    
    func buildProfileData() -> ProfileData? {
        guard validateProfileData() else {
            return nil
        }

        return ProfileData(
            firstName: firstName,
            lastName: lastName,
            isPhotographer: isPhotographer,
            isModel: isModel,
            isStudio: isStudio,
            streetName: streetName,
            houseNumber: houseNumber,
            city: city,
            postalCode: postalCode
        )
    }
    
    func registerUser(
        loginViewModel: LoginViewModel,
        email: String,
        username: String,
        password: String,
        passwordValidation: String,
        searchFilter: FilterViewModel
    ) {
        guard let profileData = buildProfileData() else {
            return
        }

        loginViewModel.registerUser(
            email: email,
            username: username,
            password: password,
            passwordValidation: passwordValidation,
            profileData: profileData,
            searchFilter: searchFilter
        )
    }

}
