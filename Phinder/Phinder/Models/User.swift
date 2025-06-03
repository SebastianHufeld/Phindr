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
    let latitude: Double?
    let longitude: Double?

    var age: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
    }

    var websiteAsURL: URL? {
        return makeURL(from: websiteURL)
    }

    var instagramAsURL: URL? {
        return makeURL(from: instagramURL)
    }

    var tiktokAsURL: URL? {
        return makeURL(from: tiktokURL)
    }

    private func makeURL(from raw: String?) -> URL? {
        guard let input = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !input.isEmpty else { return nil }
        let final = input.starts(with: "http") ? input : "https://\(input)"
        return URL(string: final)
    }
    
    var contactEmailAsURL: URL? {
        guard let email = contactEmail, !email.isEmpty, let url = URL(string: "mailto:\(email)") else { return nil }
        return url
    }
}

extension User: Identifiable {
    var id: String { userId }
}
