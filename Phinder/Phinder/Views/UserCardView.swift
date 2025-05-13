//
//  UserCardView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 13.05.25.
//

import SwiftUI

struct UserCardView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(user.username)
                .font(.headline)

            Text("\(user.age) Jahre alt, \(user.city)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                if user.isModel { Label("Model", systemImage: "person.fill") }
                if user.isPhotographer { Label("Fotograf", systemImage: "camera") }
                if user.isStudio { Label("Studio", systemImage: "building.2") }
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
    }
}


//#Preview {
//    UserCardView()
//}
