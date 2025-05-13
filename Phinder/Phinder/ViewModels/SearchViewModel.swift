//
//  SearchViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 12.05.25.
//

import Foundation
import FirebaseFirestore

@MainActor
class SearchViewModel: ObservableObject {
    @Published var matchingUsers: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()

    func searchUsers(with filter: FilterViewModel) async {
        isLoading = true
        errorMessage = nil
        var query: Query = db.collection("users")

        // Geschlecht
        if !filter.gender.isEmpty {
            query = query.whereField("gender", isEqualTo: filter.gender)
        }

        // Erfahrung
        if !filter.experienceLevel.isEmpty {
            query = query.whereField("experienceLevel", isEqualTo: filter.experienceLevel)
        }

        // Tattoos
        if filter.hasTattoos {
            query = query.whereField("hasTattoos", isEqualTo: true)
        }

        // Piercings
        if filter.hasPiercings {
            query = query.whereField("hasPiercings", isEqualTo: true)
        }

        // Shooting Kategorien (mind. 1 muss enthalten sein)
        if !filter.shootingCategories.isEmpty {
            query = query.whereField("shootingCategories", arrayContainsAny: filter.shootingCategories)
        }

        do {
            let snapshot = try await query.getDocuments()
            var users = try snapshot.documents.map { try $0.data(as: User.self) }

            // Alter lokal filtern
            users = users.filter { user in
                let age = user.age
                return age >= Int(filter.minAge ?? 18) && age <= Int(filter.maxAge ?? 99)
            }

            // Optional: Ort/Postleitzahl filtern (falls du sowas hast)

            self.matchingUsers = users
        } catch {
            self.errorMessage = "Fehler bei Suche: \(error.localizedDescription)"
            print(error)
        }

        isLoading = false
    }
}
