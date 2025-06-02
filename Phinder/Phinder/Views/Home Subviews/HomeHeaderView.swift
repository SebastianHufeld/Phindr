//
//  HomeHeaderView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 02.06.25.
//

import SwiftUI

struct HomeHeaderView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Binding var showProfileEdit: Bool

    var body: some View {
        HStack {
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

            VStack(alignment: .leading) {
                Text("Hallo \(loginViewModel.user?.firstName ?? "Gast")")
                    .font(.title2)

                Text(loginViewModel.user?.city ?? "Kein Standort")
                    .font(.subheadline)
                    .foregroundColor(.gray)

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
