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

    private let firestoreDb = Firestore.firestore()

    func searchUsers(with filter: FilterViewModel) async {
        isLoading = true
        errorMessage = nil
        var query: Query = firestoreDb.collection("users")
        if !filter.gender.isEmpty {
            query = query.whereField("gender", isEqualTo: filter.gender)
        }

        if !filter.experienceLevel.isEmpty {
            query = query.whereField("experienceLevel", isEqualTo: filter.experienceLevel)
        }

        if filter.hasTattoos {
            query = query.whereField("hasTattoos", isEqualTo: true)
        }

        if filter.hasPiercings {
            query = query.whereField("hasPiercings", isEqualTo: true)
        }

        if !filter.shootingCategories.isEmpty {
            query = query.whereField("shootingCategories", arrayContainsAny: filter.shootingCategories)
        }

        do {
            let snapshot = try await query.getDocuments()
            var users = try snapshot.documents.map { try $0.data(as: User.self) }

            
            users = users.filter { user in
                let age = user.age
                return age >= Int(filter.minAge ?? 18) && age <= Int(filter.maxAge ?? 99)
            }

            self.matchingUsers = users
        } catch {
            self.errorMessage = "Fehler bei Suche: \(error.localizedDescription)"
            print(error)
        }

        isLoading = false
    }
}
