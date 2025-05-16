//
//  ExperienceLevelSelectView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 15.05.25.
//

import SwiftUI

struct ExperienceLevelSelectView: View {
    @ObservedObject var viewModel: FilterViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Erfahrungslevel").bold()
            HStack {
                ForEach(viewModel.experienceLevels, id: \.self) { level in
                    Button(action: {
                        viewModel.experienceLevel = level
                    }) {
                        Text(level)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.experienceLevel == level ? .black : .gray.opacity(0.2))
                            .foregroundColor(viewModel.experienceLevel == level ? .white : .black)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
