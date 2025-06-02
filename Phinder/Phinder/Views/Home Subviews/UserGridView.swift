//
//  UserGridView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 02.06.25.
//

import SwiftUI

struct UserGridView: View {
    let users: [User]
    let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(users, id: \.userId) { user in
                    NavigationLink(value: user) {
                        UserCardView(user: user)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
