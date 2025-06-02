//
//  HomeViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 02.06.25.
//

import Foundation
import FirebaseFirestore
import CoreLocation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var nearbyUsers: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreDb = Firestore.firestore()
    private let geocoder = CLGeocoder()

    func loadNearbyUsers(user: User, distance: Double) async {
        isLoading = true
        errorMessage = nil

        guard let userLat = user.latitude, let userLon = user.longitude else {
            errorMessage = "Benutzerprofil hat keine Standortdaten."
            isLoading = false
            return
        }

        let userLocation = CLLocation(latitude: userLat, longitude: userLon)

        do {
            let snapshot = try await firestoreDb.collection("users").getDocuments()
            let allUsers = try snapshot.documents.map { try $0.data(as: User.self) }
            print("Alle User aus Firestore: \(allUsers.count)")
            for user in allUsers {
                print("User: \(user.username), Lat: \(String(describing: user.latitude)), Lon: \(String(describing: user.longitude))")
            }

            self.nearbyUsers = allUsers.filter { otherUser in
                guard let otherLat = otherUser.latitude,
                      let otherLon = otherUser.longitude,
                      otherUser.userId != user.userId else {
                    return false
                }

                let otherLocation = CLLocation(latitude: otherLat, longitude: otherLon)
                let distanceToUser = userLocation.distance(from: otherLocation) / 1000

                return distanceToUser <= distance
            }
            print("Nearby Users gefunden: \(nearbyUsers.count)")

        } catch {
            errorMessage = "Fehler beim Laden der Benutzer: \(error.localizedDescription)"
            print("🔥 Firestore Fehler: \(error.localizedDescription)")
        }

        isLoading = false
    }

}
