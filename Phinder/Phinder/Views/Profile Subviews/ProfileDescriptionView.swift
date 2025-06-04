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
        ZStack {
            if let text = user.descriptionText, !text.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text(text)
                        .font(.body)
                        .foregroundColor(.primary)

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
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack {
                    Text("Keine Beschreibung vorhanden.")
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding(.top, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $showEdit) {
            EditDescriptionView(user: user)
        }
    }
}


