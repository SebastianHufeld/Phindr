//
//  SearchView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var filterViewModel = FilterViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    
    @State private var selectedSearchType: SearchType = .model
    @State private var location: String = ""
    @State private var distance: Double = 50
    @State private var showValidationAlert = false
    @State private var validationMessage = ""

    @State private var searchResults: [User] = []
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Ort", text: $location)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .onChange(of: location) {
                                filterViewModel.location = location
                            }

                        VStack(alignment: .leading) {
                            Text("Entfernung")
                            Slider(value: $distance, in: 0...200, step: 1)
                            Text("\(Int(distance)) km")
                        }
                        .padding(.horizontal)
                        .onChange(of: distance) {
                            filterViewModel.distance = distance
                        }

                        Picker("Suche nach", selection: $selectedSearchType) {
                            ForEach(SearchType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .onChange(of: selectedSearchType) {
                            filterViewModel.selectedSearchType = selectedSearchType
                        }

                        if selectedSearchType == .model {
                            AgeRangeSelectorView(viewModel: filterViewModel)
                                .padding(.horizontal)
                        }

                        if selectedSearchType != .studio {
                            GenderSelectView(viewModel: filterViewModel)
                                .padding(.horizontal)
                            ExperienceLevelSelectView(viewModel: filterViewModel)
                                .padding(.horizontal)
                            CategoriesSelectView(viewModel: filterViewModel)
                                .padding(.horizontal)
                        }

                        if selectedSearchType == .model {
                            Toggle("Tattoos", isOn: $filterViewModel.hasTattoos)
                                .padding(.horizontal)
                            Toggle("Piercings", isOn: $filterViewModel.hasPiercings)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Suche")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        filterViewModel.resetFilters()
                        location = ""
                        distance = 50
                        selectedSearchType = .model
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            if filterViewModel.isValid() {
                                await searchViewModel.searchUsers(with: filterViewModel)
                                DispatchQueue.main.async {
                                    searchResults = searchViewModel.matchingUsers
                                    path.append("searchResultsList")
                                }
                            } else {
                                validationMessage = filterViewModel.missingFieldsMessage()
                                showValidationAlert = true
                            }
                        }
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "searchResultsList" {
                    SearchResultView(users: searchResults)
                }
            }
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
        }
        .alert("Fehlende Angaben", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationMessage)
        }
    }
}
