//
//  GenderSelectView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 15.05.25.
//

import SwiftUI

struct GenderSelectView: View {
    @ObservedObject var viewModel: FilterViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Geschlecht").bold()
            HStack {
                ForEach(viewModel.genders, id: \.self) { gender in
                    Button(action: {
                        viewModel.gender = gender
                    }) {
                        Text(gender)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.gender == gender ? .black : .gray.opacity(0.2))
                            .foregroundColor(viewModel.gender == gender ? .white : .black)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
