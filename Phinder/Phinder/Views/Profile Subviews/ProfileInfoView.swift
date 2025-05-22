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
            Group {
                InfoRow(label: "Name", value: "\(user.firstName) \(user.lastName)")
                InfoRow(label: "Alter", value: "\(user.age)")
                InfoRow(label: "Ort", value: "\(user.postalCode) \(user.city)")
                InfoRow(label: "Geschlecht", value: user.gender)
                InfoRow(label: "Erfahrung", value: user.experienceLevel)
            }

            if user.isPhotographer { InfoRow(label: "Rolle", value: "Fotograf") }
            if user.isModel { InfoRow(label: "Rolle", value: "Model") }
            if user.isStudio { InfoRow(label: "Rolle", value: "Studio") }

            InfoRow(label: "Kategorien", value: user.shootingCategories.joined(separator: ", "))
            InfoRow(label: "Tattoos", value: user.hasTattoos ? "Ja" : "Nein")
            InfoRow(label: "Piercings", value: user.hasPiercings ? "Ja" : "Nein")
        }
        .padding()
    }

    struct InfoRow: View {
        let label: String
        let value: String

        var body: some View {
            HStack {
                Text("\(label):")
                    .fontWeight(.semibold)
                Spacer()
                Text(value)
            }
        }
    }
}
