//
//  EditContactView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.05.25.
//

import SwiftUI

struct EditContactView: View {
    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel
    @Binding var user: User?

    @Binding var showContactEmail: Bool
    @Binding var showWebsite: Bool
    @Binding var showInstagram: Bool
    @Binding var showTikTok: Bool

    @State private var editedContactEmail: String = ""
    @State private var editedWebsiteURL: String = ""
    @State private var editedInstagramURL: String = ""
    @State private var editedTiktokURL: String = ""

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Sichtbarkeit der Informationen") {
                    Toggle("Kontakt E-Mail anzeigen", isOn: $showContactEmail)
                    Toggle("Website anzeigen", isOn: $showWebsite)
                    Toggle("Instagram anzeigen", isOn: $showInstagram)
                    Toggle("TikTok anzeigen", isOn: $showTikTok)
                }

                Section("Kontaktinformationen bearbeiten") {
                    TextField("Kontakt E-Mail", text: $editedContactEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    TextField("Website URL", text: $editedWebsiteURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)

                    TextField("Instagram URL", text: $editedInstagramURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)

                    TextField("TikTok URL", text: $editedTiktokURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Kontaktdaten bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        Task {
                            await currentUserViewModel.updateContactInfo(
                                contactEmail: editedContactEmail.isEmpty ? nil : editedContactEmail,
                                websiteURL: editedWebsiteURL.isEmpty ? nil : editedWebsiteURL,
                                instagramURL: editedInstagramURL.isEmpty ? nil : editedInstagramURL,
                                tiktokURL: editedTiktokURL.isEmpty ? nil : editedTiktokURL
                            )
                            dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            if let currentUser = user {
                editedContactEmail = currentUser.contactEmail ?? ""
                editedWebsiteURL = currentUser.websiteURL ?? ""
                editedInstagramURL = currentUser.instagramURL ?? ""
                editedTiktokURL = currentUser.tiktokURL ?? ""
            }
        }
    }
}
