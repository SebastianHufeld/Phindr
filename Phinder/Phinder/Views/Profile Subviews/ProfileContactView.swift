//
//  ProfileContactView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.05.25.
//

import SwiftUI

struct ProfileContactView: View {
    let user: User?

    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel
    @State private var showEditSheet = false

    @State private var showContactEmail = true
    @State private var showWebsite = true
    @State private var showInstagram = true
    @State private var showTikTok = true

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Kontaktdaten")
                    .font(.headline)
                Spacer()
                if let actualUser = user,
                   let currentUser = currentUserViewModel.user,
                   actualUser.userId == currentUser.userId {
                    Button("Bearbeiten") {
                        showEditSheet = true
                    }
                }
            }
            .padding(.bottom, 5)

            if let displayedUser = user {
                let hasNoContactInfo =
                    (displayedUser.contactEmail?.isEmpty ?? true) &&
                    (displayedUser.websiteURL?.isEmpty ?? true) &&
                    (displayedUser.instagramURL?.isEmpty ?? true) &&
                    (displayedUser.tiktokURL?.isEmpty ?? true)

                if hasNoContactInfo {
                    Text("Keine Kontaktdaten bekannt.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    if showContactEmail, let url = displayedUser.contactEmailAsURL {
                        LinkRow(label: "Kontakt E-Mail", value: "E-Mail", url: url, showValueText: false)
                    }
                    if showWebsite, let url = displayedUser.websiteAsURL {
                        LinkRow(label: "Website", value: "Website", url: url, showValueText: false)
                    }
                    if showInstagram, let url = displayedUser.instagramAsURL {
                        LinkRow(label: "Instagram", value: "Instagram", url: url, showValueText: false)
                    }
                    if showTikTok, let url = displayedUser.tiktokAsURL {
                        LinkRow(label: "TikTok", value: "TikTok", url: url, showValueText: false)
                    }
                }
            } else {
                Text("Keine Kontaktdaten verfügbar.")
                    .foregroundColor(.gray)
                    .italic()
            }
        }
        .padding()
        .sheet(isPresented: $showEditSheet) {
            if let actualUser = user {
                EditContactView(
                    user: $currentUserViewModel.user,
                    showContactEmail: $showContactEmail,
                    showWebsite: $showWebsite,
                    showInstagram: $showInstagram,
                    showTikTok: $showTikTok
                )
                .environmentObject(currentUserViewModel)
            }
        }
    }
}



