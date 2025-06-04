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
    
    @Published var location: String = ""
    @Published var distance: Double = 50
    @Published var selectedSearchType: SearchType = .model
    @Published var gender: String = ""
    @Published var birthdate: Date = Date()
    @Published var experienceLevel: String = ""
    @Published var shootingCategories: [String] = []
    @Published var hasTattoos: Bool = false
    @Published var hasPiercings: Bool = false
    @Published var minAgeText: String = ""
    @Published var maxAgeText: String = ""
    @Published var revision = UUID()

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

    func missingFieldsMessage() -> String {
        var missing: [String] = []

        if location.isEmpty {
            missing.append("Ort")
        }
        if gender.isEmpty {
            missing.append("Geschlecht")
        }
        if experienceLevel.isEmpty {
            missing.append("Erfahrung")
        }
        if shootingCategories.isEmpty {
            missing.append("Kategorien")
        }
        if selectedSearchType == .model && (minAgeText.isEmpty || maxAgeText.isEmpty) {
            missing.append("Altersbereich")
        }

        return "Bitte folgende Felder ausfüllen:\n" + missing.joined(separator: ", ")
    }
    
    func resetFilters() {
        location = ""
        distance = 50
        selectedSearchType = .model
        gender = ""
        birthdate = Date()
        experienceLevel = ""
        shootingCategories = []
        hasTattoos = false
        hasPiercings = false
        minAgeText = ""
        maxAgeText = ""
        revision = UUID()
    }

}

