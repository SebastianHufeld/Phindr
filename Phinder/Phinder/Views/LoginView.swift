//
//  LoginView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUpSheet = false
    
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            SecureField("Passwort", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            if let errorMessage = loginViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            Button("Login") {
                loginViewModel.loginUser(withEmail: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            
            Button("Noch keinen Account? Jetzt Registrieren!") {
                showSignUpSheet = true
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showSignUpSheet) {
            SignUpView()
                .presentationDragIndicator(.visible)
        }
    }
}

//#Preview {
//    LoginView()
//        .environmentObject(LoginViewModel())
//}
