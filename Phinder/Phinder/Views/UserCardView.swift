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
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: user.profileImageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                Color.gray
                    .frame(width: 150, height: 150)
                    .cornerRadius(8)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    )
            }

            Text(user.username)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)

            if user.age > 0 {
                Text("\(user.age) Jahre, \(user.city)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            } else {
                Text("Alter unbekannt, \(user.city)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(5)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
