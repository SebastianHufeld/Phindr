//
//  FilterView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 02.06.25.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: FilterViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Filter Optionen")
                    .font(.title)
                    .padding()
                
                VStack(alignment: .leading) {
                    TextField("Ort", text: $viewModel.location)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Entfernung")
                        Slider(value: $viewModel.distance, in: 0...200, step: 1)
                        Text("\(Int(viewModel.distance)) km")
                    }.padding()
                    
                    Picker("Suche nach", selection: $viewModel.selectedSearchType) {
                        ForEach(SearchType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if viewModel.selectedSearchType == .model {
                        AgeRangeSelectorView(viewModel: viewModel)
                            .padding(.horizontal)
                    }
                    
                    if viewModel.selectedSearchType != .studio {
                        GenderSelectView(viewModel: viewModel)
                            .padding(.horizontal)
                        ExperienceLevelSelectView(viewModel: viewModel)
                            .padding(.horizontal)
                        CategoriesSelectView(viewModel: viewModel)
                            .padding(.horizontal)
                    }
                    
                    if viewModel.selectedSearchType == .model {
                        Toggle("Tattoos", isOn: $viewModel.hasTattoos)
                            .padding(.horizontal)
                        Toggle("Piercings", isOn: $viewModel.hasPiercings)
                            .padding(.horizontal)
                    }
                    
                    Button("Anwenden") {
                        viewModel.revision = UUID()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
