//
//  EditDescriptionView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.05.25.
//

import SwiftUI

struct EditDescriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State var user: User
    @State private var text: String = ""
    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .padding()
                .onAppear {
                    text = user.descriptionText ?? ""
                }

            Button("Speichern") {
                Task {
                    await currentUserViewModel.updateDescriptionText(text)
                    dismiss()
                }
            }
            .padding()
        }
    }
}
