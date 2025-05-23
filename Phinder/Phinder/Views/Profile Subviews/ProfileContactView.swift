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
                if let actualUser = user, let currentUser = currentUserViewModel.user, actualUser.userId == currentUser.userId {
                    Button("Bearbeiten") {
                        showEditSheet = true
                    }
                }
            }
            .padding(.bottom, 5)

            if let displayedUser = user {
                if showContactEmail, let contactEmail = displayedUser.contactEmail, !contactEmail.isEmpty {
                    LinkRow(label: "Kontakt E-Mail", value: contactEmail, url: displayedUser.contactEmailAsURL, showValueText: true)
                }

                if showWebsite, let websiteURL = displayedUser.websiteAsURL {
                    LinkRow(label: "Website", value: displayedUser.websiteURL ?? "", url: websiteURL, showValueText: false)
                }

                if showInstagram, let instagramURL = displayedUser.instagramAsURL {
                    LinkRow(label: "Instagram", value: displayedUser.instagramURL ?? "", url: instagramURL, showValueText: false)
                }

                if showTikTok, let tiktokURL = displayedUser.tiktokAsURL {
                    LinkRow(label: "TikTok", value: displayedUser.tiktokURL ?? "", url: tiktokURL, showValueText: false)
                }
            } else {
                Text("Keine Kontaktdaten verfügbar.")
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
        .onAppear {
            if let actualUser = user, let currentUser = currentUserViewModel.user, actualUser.userId == currentUser.userId {
            }
        }
    }
}


