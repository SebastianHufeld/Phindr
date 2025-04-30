//
//  HomeView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.04.25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        HStack {
            Image("Ich_Kamera")
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
                .frame(width: 150, height: 250)
            
            VStack(alignment: .leading) {
                Text("Hallo \(loginViewModel.user?.firstName ?? "Gast")")
                    .font(.title2)
                
                Button("Profil bearbeiten") {
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
