//
//  ProfileView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct ProfileView: View {
    let user: User?
    @State private var selectedTab: String = "Fotos"
    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel

    private var displayedUser: User? {
        user ?? currentUserViewModel.user
    }

    var isOwnProfile: Bool {
        guard let actualUser = displayedUser, let currentUser = currentUserViewModel.user else {
            return false
        }
        return actualUser.userId == currentUser.userId
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
                                        .background(selectedTab == tab ? Color(red: 0.96, green: 0.91, blue: 0.70).opacity(0.8) : Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                .foregroundStyle(.primary)
                            }

                            if isOwnProfile {
                                NavigationLink(destination: ProfileEditView(user: actualUser, loginViewModel: loginViewModel)) {
                                    Text("Einstellungen")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                .foregroundStyle(.primary)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 8)

                    if selectedTab == "Fotos" {
                        ProfilePhotosView(user: actualUser, isOwnProfile: isOwnProfile)
                            .environmentObject(currentUserViewModel)
                    } else if selectedTab == "Info" {
                        ProfileInfoView(user: actualUser)
                    } else if selectedTab == "Beschreibung" {
                        ProfileDescriptionView(user: actualUser, isOwnProfile: isOwnProfile)
                    } else if selectedTab == "Kontakt" {
                        ProfileContactView(user: actualUser)
                    }
                } else {
                    Text("Profil konnte nicht geladen werden.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .navigationTitle(isOwnProfile ? "Mein Profil" : "Profil")
        .navigationBarTitleDisplayMode(.inline)
    }
}


