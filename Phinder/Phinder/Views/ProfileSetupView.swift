//
//  ProfileSetupView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 28.04.25.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var viewModel = ProfileSetupViewModel()

    var body: some View {
        Form {
            Section(header: Text("Wähle deine Rolle")) {
                Toggle("Fotograf", isOn: $viewModel.isPhotographer)
                Toggle("Model", isOn: $viewModel.isModel)
                Toggle("Studio", isOn: $viewModel.isStudio)
            }

            Section(header: Text("Persönliche Daten")) {
                TextField("Vorname", text: $viewModel.firstName)
                TextField("Nachname", text: $viewModel.lastName)
                TextField("Straßenname", text: $viewModel.streetName)
                TextField("Hausnummer", value: $viewModel.houseNumber, format: .number)
                TextField("Stadt", text: $viewModel.city)
                TextField("Postleitzahl", value: $viewModel.postalCode, format: .number)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Profil anlegen") {
                viewModel.saveProfile(loginViewModel: loginViewModel)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Profil vervollständigen")
    }
}

#Preview {
    NavigationStack {
        ProfileSetupView()
            .environmentObject(LoginViewModel())
    }
}
