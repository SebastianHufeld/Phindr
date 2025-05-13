//
//  SearchView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var filterViewModel = FilterViewModel()
    @StateObject private var searchViewModel = SearchViewModel()

    @State private var location: String = ""
    @State private var distance: Double = 50

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    TextField("Ort", text: $location)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text("Entfernung")
                        Slider(value: $distance, in: 0...200, step: 1)
                        Text("\(Int(distance)) km")
                    }.padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Alter").bold()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Von:")
                                TextField("z. B. 18", text: $filterViewModel.minAgeText)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }

                            VStack(alignment: .leading) {
                                Text("Bis:")
                                TextField("z. B. 99", text: $filterViewModel.maxAgeText)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }

                        if let min = filterViewModel.minAge, let max = filterViewModel.maxAge, min > max {
                            Text("Bitte gültigen Altersbereich eingeben.")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }.padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text("Geschlecht").bold()
                        HStack {
                            ForEach(filterViewModel.genders, id: \.self) { gender in
                                Button(action: {
                                    filterViewModel.gender = gender
                                }) {
                                    Text(gender)
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .background(filterViewModel.gender == gender ? Color.black : Color.gray.opacity(0.2))
                                        .foregroundColor(filterViewModel.gender == gender ? .white : .black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }.padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text("Erfahrung").bold()
                        HStack {
                            ForEach(filterViewModel.experienceLevels, id: \.self) { level in
                                Button(action: {
                                    filterViewModel.experienceLevel = level
                                }) {
                                    Text(level)
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .background(filterViewModel.experienceLevel == level ? Color.black : Color.gray.opacity(0.2))
                                        .foregroundColor(filterViewModel.experienceLevel == level ? .white : .black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }.padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text("Bereiche").bold()
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                            ForEach(filterViewModel.categories, id: \.self) { category in
                                Button(action: {
                                    if filterViewModel.shootingCategories.contains(category) {
                                        filterViewModel.shootingCategories.removeAll { $0 == category }
                                    } else {
                                        filterViewModel.shootingCategories.append(category)
                                    }
                                }) {
                                    Text(category)
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .background(filterViewModel.shootingCategories.contains(category) ? Color.black : Color.gray.opacity(0.2))
                                        .foregroundColor(filterViewModel.shootingCategories.contains(category) ? .white : .black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }.padding(.horizontal)

                    Toggle("Tattoos", isOn: $filterViewModel.hasTattoos)
                        .padding(.horizontal)
                    Toggle("Piercings", isOn: $filterViewModel.hasPiercings)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Suche")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if filterViewModel.isValid() {
                            Task {
                                await searchViewModel.searchUsers(with: filterViewModel)
                            }
                        } else {
                            print("Bitte alle Pflichtfelder ausfüllen")
                        }
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}



//#Preview {
//    SearchView()
//        .environmentObject(LoginViewModel())
//}
