//
//  ProfileDescriptionView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.05.25.
//

import SwiftUI

struct ProfileDescriptionView: View {
    let user: User
    let isOwnProfile: Bool

    @State private var showEdit = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(user.descriptionText ?? "Keine Beschreibung vorhanden.")
                .font(.body)
                .padding()

            if isOwnProfile {
                Button("Beschreibung bearbeiten") {
                    showEdit = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showEdit) {
            EditDescriptionView(user: user)
        }
    }
}
