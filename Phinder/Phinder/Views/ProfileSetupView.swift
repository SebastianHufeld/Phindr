import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var setupViewModel = ProfileSetupViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let email: String
    let userName: String
    let password: String
    let passwordValidation: String
    
    var body: some View {
        Form {
            Section(header: Text("Wähle deine Rolle")) {
                Toggle("Fotograf", isOn: $setupViewModel.isPhotographer)
                Toggle("Model", isOn: $setupViewModel.isModel)
                Toggle("Studio", isOn: $setupViewModel.isStudio)
            }
            
            Section(header: Text("Persönliche Daten")) {
                TextField("Vorname", text: $setupViewModel.firstName)
                TextField("Nachname", text: $setupViewModel.lastName)
                TextField("Straßenname", text: $setupViewModel.streetName)
                TextField("Hausnummer", value: $setupViewModel.houseNumber, format: .number)
                TextField("Stadt", text: $setupViewModel.city)
                TextField("Postleitzahl", value: $setupViewModel.postalCode, format: .number)
            }
            
            if let errorMessage = setupViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            if let errorMessage = loginViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button {
                setupViewModel.registerUser(
                    loginViewModel: loginViewModel,
                    email: email,
                    username: userName,
                    password: password,
                    passwordValidation: passwordValidation
                )
            } label: {
                if loginViewModel.isRegistrationInProgress {
                    ProgressView()
                } else {
                    Text("Profil anlegen")
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .disabled(loginViewModel.isRegistrationInProgress)
        }
        
        .onChange(of: loginViewModel.user) {
            if loginViewModel.user != nil {
                dismiss()
            }
        }
    }
}
