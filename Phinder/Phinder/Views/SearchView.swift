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
                        
                        VStack(alignment: .leading) {
                            Text("Entfernung")
                            Slider(value: $distance, in: 0...200, step: 1)
                            Text("\(Int(distance)) km")
                        }.padding(.horizontal)
                        
                        Picker("Suche nach", selection: $selectedSearchType) {
                            ForEach(SearchType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            if filterViewModel.isValid() {
                                await searchViewModel.searchUsers(with: filterViewModel)
                                searchResults = searchViewModel.matchingUsers
                                // Hier navigieren wir zu einem String-Literal "searchResultsList"
                                // Das wird dann in der .navigationDestination unten abgefangen
                                path.append("searchResultsList")
                            } else {
                                print("Bitte alle Pflichtfelder ausfüllen")
                            }
                        }
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            // Neue navigationDestination für die SearchResultView
            .navigationDestination(for: String.self) { value in
                if value == "searchResultsList" {
                    SearchResultView(users: searchResults)
                }
            }
            // Bestehende navigationDestination für die ProfileView
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
        }
    }
}
