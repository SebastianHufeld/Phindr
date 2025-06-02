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
    @StateObject private var currentUserViewModel = CurrentUserViewModel()
    @StateObject private var loginViewModel: LoginViewModel

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        let currentUserVM = CurrentUserViewModel()
        _currentUserViewModel = StateObject(wrappedValue: currentUserVM)
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(currentUserViewModel: currentUserVM))
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


