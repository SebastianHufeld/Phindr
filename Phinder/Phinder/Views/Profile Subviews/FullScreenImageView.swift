//
//  FullScreenImageView.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 22.05.25.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageURLs: [String] 
    let initialIndex: Int
    var dismissAction: () -> Void

    @State private var currentIndex: Int

    init(imageURLs: [String], initialIndex: Int, dismissAction: @escaping () -> Void) {
        self.imageURLs = imageURLs
        self.initialIndex = initialIndex
        self.dismissAction = dismissAction
        self._currentIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            TabView(selection: $currentIndex) {
                ForEach(Array(imageURLs.enumerated()), id: \.offset) { index, imageURL in
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismissAction()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                Spacer()
                
                if imageURLs.count > 1 {
                    HStack(spacing: 8) {
                        ForEach(0..<imageURLs.count, id: \.self) { index in
                            Circle()
                                .fill(currentIndex == index ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}
