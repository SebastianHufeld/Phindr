//
//  ProfileView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct ProfileView: View {
    let user: User?

    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTab: String = "Fotos"
    @State private var reloadKey = UUID()

    private var displayedUser: User? {
        user ?? currentUserViewModel.user
    }

    private var isOwnProfile: Bool {
        if let displayedUser = displayedUser,
           let currentUser = currentUserViewModel.user {
            return displayedUser.userId == currentUser.userId
        }
        return false
    }

    var body: some View {
        ScrollView {
            VStack {
                if let actualUser = displayedUser {
                    AsyncImage(url: URL(string: actualUser.profileImageURL ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    } placeholder: {
                        Color.gray.frame(height: 300)
                    }

                    Text("\(actualUser.firstName) (\(actualUser.age)) aus \(actualUser.city)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 8)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(["Fotos", "Beschreibung", "Kontakt", "Info"], id: \.self) { tab in
                                Button {
                                    selectedTab = tab
                                } label: {
                                    Text(tab)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(selectedTab == tab ? Color("PhinderGreen").opacity(0.8) : Color.gray.opacity(0.1))
                                        .foregroundColor(selectedTab == tab ? .white : .primary)
                                        .cornerRadius(10)
                                }
                            }

                            if isOwnProfile {
                                NavigationLink(destination: ProfileEditView(user: actualUser, loginViewModel: loginViewModel)) {
                                    Text("Einstellungen")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.1))
                                        .foregroundColor(.primary)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if selectedTab == "Fotos" {
                        ProfilePhotosView(user: actualUser, isOwnProfile: isOwnProfile)
                    } else if selectedTab == "Beschreibung" {
                        ProfileDescriptionView(user: actualUser, isOwnProfile: isOwnProfile)
                    } else if selectedTab == "Kontakt" {
                        ProfileContactView(user: actualUser)
                    } else if selectedTab == "Info" {
                        ProfileInfoView(user: actualUser)
                    }

                } else {
                    Text("Profil konnte nicht geladen werden.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .id(reloadKey)
        .onChange(of: currentUserViewModel.user?.profileImageURL) {
            if user == nil {
                reloadKey = UUID()
            }
        }
        .navigationTitle(isOwnProfile ? "Mein Profil" : "Profil")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Zurück")
                    }
                }
            }
        }
    }
}
