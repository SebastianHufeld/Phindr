//
//  SearchResultView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 12.05.25.
//

import SwiftUI

struct SearchResultView: View {
    let users: [User]

    var body: some View {
        List(users, id: \.userId) { user in
            VStack(alignment: .leading) {
                Text(user.username).font(.headline)
                Text("\(user.age) Jahre, \(user.city)")
                Text(user.shootingCategories.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Suchergebnisse")
    }
}

//
//#Preview {
//    SearchResultView()
//}
