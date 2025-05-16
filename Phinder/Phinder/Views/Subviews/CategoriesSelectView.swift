//
//  CategoriesSelectView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 15.05.25.
//

import SwiftUI

struct CategoriesSelectView: View {
    @ObservedObject var viewModel: FilterViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Shooting-Kategorien").bold()
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button(action: {
                        viewModel.toggleCategory(category)
                    }) {
                        Text(category)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.shootingCategories.contains(category) ? .black : .gray.opacity(0.2))
                            .foregroundColor(viewModel.shootingCategories.contains(category) ? .white : .black)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
