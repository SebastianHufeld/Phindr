//
//  FilterViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 06.05.25.
//

import Foundation

@MainActor
class FilterViewModel: ObservableObject {
    let genders = ["Männlich", "Weiblich", "Divers"]
    let experienceLevels = ["Anfänger", "Semiprofi", "Profi"]
    let categories = ["Portrait", "Lingerie", "Studio", "Teilakt", "Akt", "Bademode"]
    @Published var gender: String = ""
    @Published var birthdate: Date = Date()
    @Published var experienceLevel: String = ""
    @Published var shootingCategories: [String] = []
    @Published var hasTattoos: Bool = false
    @Published var hasPiercings: Bool = false
    @Published var minAgeText: String = ""
    @Published var maxAgeText: String = ""
    func isValid() -> Bool {
        !gender.isEmpty && !experienceLevel.isEmpty && !shootingCategories.isEmpty
    }
    var minAge: Int? {
        Int(minAgeText)
    }
    var maxAge: Int? {
        Int(maxAgeText)
    }
    func toggleCategory(_ category: String) {
        if shootingCategories.contains(category) {
            shootingCategories.removeAll { $0 == category }
        } else {
            shootingCategories.append(category)
        }
    }
}
