//
//  ProfileView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct ProfileView: View {
    let user: User?
    @State private var selectedTab: String = "Fotos"
    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel

    var isOwnProfile: Bool {
        guard let user = user, let currentUser = currentUserViewModel.user else {
            return false
        }
        return user.userId == currentUser.userId
    }

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: (user ?? currentUserViewModel.user)?.profileImageURL ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                } placeholder: {
                    Color.gray.frame(height: 300)
                }

                Text("\((user ?? currentUserViewModel.user)!.firstName) (\((user ?? currentUserViewModel.user)!.age)) aus \((user ?? currentUserViewModel.user)!.city)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(["Fotos", "Info"], id: \.self) { tab in
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab)
                                    .padding()
                                    .frame(maxWidth: .infinity) // Wichtig: Hier wieder .infinity
                                    .background(selectedTab == tab ? Color(red: 0.96, green: 0.91, blue: 0.70).opacity(0.8) : Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .foregroundStyle(.primary)
                        }

                        if isOwnProfile {
                            NavigationLink(destination: ProfileEditView(user: user, loginViewModel: loginViewModel)) {
                                Text("Einstellungen")
                                    .padding()
                                    .frame(maxWidth: .infinity) // Wichtig: Auch hier .infinity
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
                    ProfilePhotosView(user: user ?? currentUserViewModel.user, isOwnProfile: isOwnProfile)
                        .environmentObject(currentUserViewModel)
                } else if selectedTab == "Info" {
                    ProfileInfoView(user: (user ?? currentUserViewModel.user)!)
                }
            }
        }
        .navigationTitle(isOwnProfile ? "Mein Profil" : "Profil")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ProfileView(user: nil)
            .environmentObject(CurrentUserViewModel())
            .environmentObject(LoginViewModel())
    }
}
