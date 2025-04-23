//
//  User.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import Foundation

struct User: Codable, Identifiable {
    var id = UUID()
    let username: String
    let mail: String
    let password: String
    let firstName: String
    let lastName: String
    let isPhotographer: Bool
    let isModel: Bool
    let isStudio: Bool
    let streetName: String
    let houseNumber: Int
    let city: String
    let postalCode: Int
}
