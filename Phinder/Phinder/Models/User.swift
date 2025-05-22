//
//  User.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import Foundation

struct User: Codable, Equatable, Hashable{
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
    var age: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
    }
}

extension User: Identifiable {
    var id: String { userId }
}
