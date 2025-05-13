import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var setupViewModel = ProfileSetupViewModel()
    @StateObject private var filterViewModel = FilterViewModel()
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
            
            Section(header: Text("Persönliche Infos")) {
                TextField("Vorname", text: $setupViewModel.firstName)
                TextField("Nachname", text: $setupViewModel.lastName)
                TextField("Straßenname", text: $setupViewModel.streetName)
                TextField("Hausnummer", text: $setupViewModel.houseNumber)
                TextField("Stadt", text: $setupViewModel.city)
                TextField("Postleitzahl", text: $setupViewModel.postalCode)
                Picker("Geschlecht", selection: $filterViewModel.gender) {
                    Text("Männlich").tag("Männlich")
                    Text("Weiblich").tag("Weiblich")
                    Text("Divers").tag("Divers")
                }

                DatePicker("Geburtsdatum", selection: $filterViewModel.birthdate, displayedComponents: .date)
            }
            
            Section(header: Text("Erfahrung & Bereiche")) {
                Picker("Erfahrung", selection: $filterViewModel.experienceLevel) {
                    Text("Anfänger").tag("Anfänger")
                    Text("Semiprofi").tag("Semiprofi")
                    Text("Profi").tag("Profi")
                }
                .pickerStyle(.segmented)

                Section("Bereiche") {
                    ForEach(["Portrait", "Studio", "Lingerie", "Teilakt", "Akt", "Bademode"], id: \.self) { category in
                        Toggle(category, isOn: Binding(
                            get: { filterViewModel.shootingCategories.contains(category) },
                            set: { isSelected in
                                if isSelected {
                                    filterViewModel.shootingCategories.append(category)
                                } else {
                                    filterViewModel.shootingCategories.removeAll { $0 == category }
                                }
                            }
                        ))
                    }
                }
            }
            Section("Tattoos & Piercings") {
                Toggle("Tätowiert", isOn: $filterViewModel.hasTattoos)
                Toggle("Piercings", isOn: $filterViewModel.hasPiercings)
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
                    passwordValidation: passwordValidation,
                    searchFilter: filterViewModel
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
