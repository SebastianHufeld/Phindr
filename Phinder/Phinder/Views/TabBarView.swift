//
//  TabBarView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 24.04.25.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }
//            Tab("Shoots", systemImage: "calendar") {
//                NavigationStack {
//                    ShootsView()
//                }
//            }
            Tab("Suche", systemImage: "magnifyingglass.circle.fill") {
                NavigationStack {
                    SearchView()
                }
            }
//            Tab("Nachrichten", systemImage: "message.fill") {
//                NavigationStack {
//                }
//            }
            Tab("Profil", systemImage: "person.crop.rectangle.fill") {
                NavigationStack {
                    if let currentUser = currentUserViewModel.user {
                        ProfileView(user: currentUser)
                    }
                }
            }
        }
        .tint(Color(red: 0.33, green: 0.46, blue: 0.33))
    }
}

#Preview {
    TabBarView()
}
