//
//  AgeRangeSelectorView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 15.05.25.
//

import SwiftUI

struct AgeRangeSelectorView: View {
    @ObservedObject var viewModel: FilterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Alter").bold()
            HStack {
                VStack {
                    Text("Von:")
                    TextField("z. B. 18", text: $viewModel.minAgeText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                VStack {
                    Text("Bis:")
                    TextField("z. B. 99", text: $viewModel.maxAgeText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
            }
            if let min = viewModel.minAge, let max = viewModel.maxAge, min > max {
                Text("Ungültiger Altersbereich.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
