//
//  ProfileEditView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 09.05.25.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProfileEditViewModel
    
    init(user: User?, loginViewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: ProfileEditViewModel(user: user, loginViewModel: loginViewModel))
    }

    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Profilbild")) {
                        HStack {
                            Spacer()
                            
                            ZStack {
                                if let image = viewModel.profileImage {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(.gray)
                                }
                                
                                if viewModel.isUploadingImage {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(1.5)
                                        .frame(width: 120, height: 120)
                                        .background(Color.black.opacity(0.4))
                                        .clipShape(Circle())
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical)
                        
                        PhotosPicker(
                            selection: $viewModel.photoPickerItem,
                            matching: .images
                        ) {
                            HStack {
                                Image(systemName: "photo")
                                Text("Profilbild ändern")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.bordered)
                        .onChange(of: viewModel.photoPickerItem) {
                            viewModel.loadSelectedImage()
                        }
                    }
                    
                    Section(header: Text("Persönliche Informationen")) {
                        TextField("Benutzername", text: $viewModel.username)
                        TextField("E-Mail", text: $viewModel.mail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        TextField("Vorname", text: $viewModel.firstName)
                        TextField("Nachname", text: $viewModel.lastName)
                        
                        Picker("Geschlecht", selection: $viewModel.gender) {
                            ForEach(viewModel.genderOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        
                        DatePicker("Geburtsdatum", selection: $viewModel.birthdate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("Rolle")) {
                        Toggle("Fotograf", isOn: $viewModel.isPhotographer)
                        Toggle("Model", isOn: $viewModel.isModel)
                        Toggle("Studio", isOn: $viewModel.isStudio)
                    }
                    
                    Section(header: Text("Adresse")) {
                        TextField("Straße", text: $viewModel.streetName)
                        TextField("Hausnummer", text: $viewModel.houseNumber)
                        TextField("Stadt", text: $viewModel.city)
                        TextField("Postleitzahl", text: $viewModel.postalCode)
                            .keyboardType(.numberPad)
                    }
                    
                    Section(header: Text("Erfahrung")) {
                        Picker("Erfahrungslevel", selection: $viewModel.experienceLevel) {
                            ForEach(viewModel.experienceLevelOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                    }
                    
                    Section(header: Text("Shooting-Kategorien")) {
                        ForEach(viewModel.availableShootingCategories, id: \.self) { category in
                            Button(action: {
                                viewModel.toggleCategory(category)
                            }) {
                                HStack {
                                    Text(category)
                                    Spacer()
                                    if viewModel.shootingCategories.contains(category) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                    Section(header: Text("Weitere Informationen")) {
                        Toggle("Tattoos", isOn: $viewModel.hasTattoos)
                        Toggle("Piercings", isOn: $viewModel.hasPiercings)
                    }
                }
                .navigationTitle("Profil bearbeiten")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Abbrechen") {
                            dismiss()
                        }
                        .disabled(viewModel.isLoading)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Speichern") {
                            Task {
                                await viewModel.saveProfile()
                            }
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.errorMessage == nil ? "Hinweis" : "Fehler"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK")) {
                            if viewModel.errorMessage == nil {
                                dismiss()
                            }
                        }
                    )
                }
                
                
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                        Text("Speichere Profil...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                    )
                    .shadow(radius: 10)
                }
            }
        }
    }
}
