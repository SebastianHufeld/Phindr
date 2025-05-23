//
//  User.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import Foundation

struct User: Codable, Equatable, Hashable {
    let userId: String
    let username: String
    let mail: String
    let firstName: String
    let lastName: String
    let gender: String
    let birthdate: Date
    let isPhotographer: Bool
    let isModel: Bool
    let isStudio: Bool
    let streetName: String
    let houseNumber: String
    let city: String
    let postalCode: String
    let experienceLevel: String
    let shootingCategories: [String]
    let hasTattoos: Bool
    let hasPiercings: Bool
    let registrationDate: Date
    var profileImageURL: String?
    var descriptionText: String?
    var websiteURL: String?
    var instagramURL: String?
    var tiktokURL: String?
    var contactEmail: String?
    var age: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
    }
    var websiteAsURL: URL? {
        guard let urlString = websiteURL, let url = URL(string: urlString) else { return nil }
        return url
    }
    
    var instagramAsURL: URL? {
        guard let urlString = instagramURL, let url = URL(string: urlString) else { return nil }
        return url
    }
    
    var tiktokAsURL: URL? {
        guard let urlString = tiktokURL, let url = URL(string: urlString) else { return nil }
        return url
    }
    
    var contactEmailAsURL: URL? {
        guard let email = contactEmail, !email.isEmpty, let url = URL(string: "mailto:\(email)") else { return nil }
        return url
    }
}

extension User: Identifiable {
    var id: String { userId }
}
