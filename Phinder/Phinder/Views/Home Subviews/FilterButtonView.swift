//
//  FilterButtonView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 02.06.25.
//

import SwiftUI

struct FilterButtonView: View {
    @Binding var showFilter: Bool

    var body: some View {
        Button(action: {
            showFilter = true
        }) {
            Image(systemName: "slider.horizontal.3")
                .font(.title)
                .padding(.trailing)
        }
    }
}
