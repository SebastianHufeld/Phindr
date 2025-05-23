//
//  ProfileInfoView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 22.05.25.
//

import SwiftUI

struct ProfileInfoView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                    if user.isStudio {
                        InfoRow(label: "Name", value: "\(user.firstName) \(user.lastName)")
                        InfoRow(label: "Ort", value: "\(user.postalCode) \(user.city)")
                    }

                    if user.isPhotographer {
                        InfoRow(label: "Name", value: "\(user.firstName) \(user.lastName)")
                        InfoRow(label: "Alter", value: "\(user.age)")
                        InfoRow(label: "Ort", value: "\(user.postalCode) \(user.city)")
                        InfoRow(label: "Geschlecht", value: user.gender)
                        InfoRow(label: "Erfahrung", value: user.experienceLevel)
                        InfoRow(label: "Kategorien", value: user.shootingCategories.joined(separator: ", "))
                    }

                    if user.isModel {
                        InfoRow(label: "Name", value: "\(user.firstName) \(user.lastName)")
                        InfoRow(label: "Alter", value: "\(user.age)")
                        InfoRow(label: "Ort", value: "\(user.postalCode) \(user.city)")
                        InfoRow(label: "Geschlecht", value: user.gender)
                        InfoRow(label: "Erfahrung", value: user.experienceLevel)
                        InfoRow(label: "Kategorien", value: user.shootingCategories.joined(separator: ", "))
                        InfoRow(label: "Tattoos", value: user.hasTattoos ? "Ja" : "Nein")
                        InfoRow(label: "Piercings", value: user.hasPiercings ? "Ja" : "Nein")
                    }
                }
        .padding()
    }
}
