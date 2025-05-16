//
//  HomeView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @State private var showProfileEdit = false

    var body: some View {
        HStack {
            ZStack {
                if let image = loginViewModel.profileImage {
                    image
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }

            VStack(alignment: .leading) {
                Text("Hallo \(loginViewModel.user?.firstName ?? "Gast")")
                    .font(.title2)

                Button("Profil bearbeiten") {
                    showProfileEdit = true
                }
                .buttonStyle(.bordered)

                Button("Ausloggen") {
                    loginViewModel.logout()
                }
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showProfileEdit) {
            if let user = loginViewModel.user {
                ProfileEditView(user: user, loginViewModel: loginViewModel)
            }
        }
    }
}
