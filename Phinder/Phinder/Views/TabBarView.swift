//
//  TabBarView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 24.04.25.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }
            Tab("Shoots", systemImage: "calendar") {
                NavigationStack {
                    ShootsView()
                }
            }
            Tab("Suche", systemImage: "magnifyingglass.circle.fill") {
                NavigationStack {
                    SearchView()
                }
            }
            Tab("Nachrichten", systemImage: "message.fill") {
                NavigationStack {
                    ProfileView()
                }
            }
            Tab("Profil", systemImage: "person.crop.rectangle.fill") {
                NavigationStack {
                    ProfileView()
                }
            }
        }
        .tint((Color(red: 0.96, green: 0.91, blue: 0.70 )))
    }
}

#Preview {
    TabBarView()
}
