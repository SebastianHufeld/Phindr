//
//  InfoRow.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 23.05.25.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.body)
        }
    }
}

struct LinkRow: View {
    let label: String
    let value: String
    let url: URL?
    var showIcon: Bool = true
    var showValueText: Bool = true

    let customColor = Color(hex: "537652")

    var body: some View {
        if let url = url {
            Link(destination: url) {
                HStack {
                    Text(label)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    HStack(spacing: 6) {
                        if showIcon, let iconInfo = iconName(for: label) {
                            if iconInfo.isSFLabel {
                                Image(systemName: iconInfo.name)
                                    .font(.body)
                                    .foregroundColor(customColor)
                            } else {
                                Image(iconInfo.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(customColor)
                            }
                        }
                        if showValueText {
                            Text(value)
                                .font(.body)
                                .underline()
                                .foregroundColor(customColor)
                        }
                    }
                }
            }
        }
    }

    private func iconName(for label: String) -> (name: String, isSFLabel: Bool)? {
        switch label {
        case "E-Mail (Registrierung)", "Kontakt E-Mail": return ("envelope.fill", true)
        case "Instagram": return ("instagram_icon", false)
        case "TikTok": return ("tiktok_icon", false)
        case "Website": return ("globe", true)
        default: return nil
        }
    }
}
