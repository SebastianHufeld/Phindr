//
//  SearchResultView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 12.05.25.
//

import SwiftUI

struct SearchResultView: View {
    let users: [User]
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            if users.isEmpty {
                Text("Keine Ergebnisse gefunden.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(users, id: \.userId) { user in
                        NavigationLink(value: user) {
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
                                
                                Text("\(user.age) Jahre, \(user.city)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            .padding(5)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationTitle("Suchergebnisse")
    }
}
