//
//  SignUpView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @State private var showProfileSetup = false
    @State private var email: String = ""
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var passwordValidation: String = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            TextField("Username", text: $userName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            SecureField("Passwort", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            SecureField("Passwort bestätigen", text: $passwordValidation)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            if let errorMessage = loginViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            Button("Weiter") {
                if loginViewModel.validateRegistration(email: email, password: password, passwordValidation: passwordValidation) {
                    showProfileSetup = true
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
        .tint(Color("PhinderGreen"))
        .sheet(isPresented: $showProfileSetup) {
            ProfileSetupView(
                email: email,
                userName: userName,
                password: password,
                passwordValidation: passwordValidation
            )
            .environmentObject(loginViewModel)
        }
    }
}
