//
//  PhinderApp.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 22.04.25.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct PhinderApp: App {
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var currentUserViewModel = CurrentUserViewModel()
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if loginViewModel.isUserLoggedIn {
                TabBarView()
                    .environmentObject(currentUserViewModel)
            } else {
                LoginView()
            }
        }
        .environmentObject(loginViewModel)
    }
}
