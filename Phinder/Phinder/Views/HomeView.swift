//
//  HomeView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @EnvironmentObject private var currentUserViewModel: CurrentUserViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showProfileEdit = false
    @State private var showFilter = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HomeHeaderView(
                    showProfileEdit: $showProfileEdit
                )
                
//                FilterButtonView(showFilter: $showFilter)
//                    .sheet(isPresented: $showFilter) {
//                        FilterView(viewModel: filterViewModel)
//                        Text("Nutzer gefunden: \(homeViewModel.nearbyUsers.count)")
//                            .padding()
//                            .foregroundColor(.blue)
//                    }
                
                UserGridView(users: homeViewModel.nearbyUsers)
                
                Spacer()
            }
            .onAppear {
                Task {
                    guard let user = currentUserViewModel.user,
                          let lat = user.latitude,
                          let lon = user.longitude else {
                        print("⚠️ Kein gültiger User oder Standort")
                        return
                    }
                    await homeViewModel.loadNearbyUsers(user: user, distance: 200)
                }
            }
            
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
        }
    }
}
