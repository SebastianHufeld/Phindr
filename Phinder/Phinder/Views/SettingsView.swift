//
//  SettingsView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 05.06.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Darstellung")) {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }

            Section {
                Button(role: .destructive) {
                    loginViewModel.logout()
                } label: {
                    HStack {
                        Image(systemName: "arrow.backward.square")
                        Text("Ausloggen")
                    }
                }
            }
        }
        .navigationTitle("Einstellungen")
    }
}

