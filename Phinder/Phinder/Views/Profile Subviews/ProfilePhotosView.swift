//
//  ProfilePhotosView.swift
//  Phinder
//  Created by Sebastian Hufeld on 22.05.25.
//

import SwiftUI
import PhotosUI

struct ProfilePhotosView: View {
    let user: User?
    let isOwnProfile: Bool

    @StateObject private var profileGalleryViewModel = ProfileGalleryViewModel()
    @EnvironmentObject var currentUserViewModel: CurrentUserViewModel

    @State private var selectedIdentifiableURL: IdentifiableURL? = nil

    var gridItems: [GridItem] = [
        GridItem(.fixed(120), spacing: 2),
        GridItem(.fixed(120), spacing: 2),
        GridItem(.fixed(120), spacing: 2)
    ]

    var body: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: gridItems, spacing: 3) {
                if isOwnProfile {
                    PhotosPicker(
                        selection: $profileGalleryViewModel.photoPickerItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 120)
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    }
                    .disabled(profileGalleryViewModel.isUploading)
                }

                ForEach(Array(profileGalleryViewModel.photoURLs.enumerated()), id: \.offset) { index, url in
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                    } placeholder: {
                        Color.gray
                            .frame(width: 120, height: 120)
                    }
                    .onTapGesture {
                        selectedIdentifiableURL = IdentifiableURL(urlString: url, index: index)
                    }
                }
            }
            .padding(.horizontal, 1)
            .padding(.vertical, 1)

            if profileGalleryViewModel.isUploading {
                ProgressView("Bild wird hochgeladen…")
                    .padding()
            } else if let errorMessage = profileGalleryViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            profileGalleryViewModel.loadUserImagesFromFirestore(for: user)
        }
        .onChange(of: profileGalleryViewModel.photoPickerItem) {
            if isOwnProfile, let userId = currentUserViewModel.user?.userId {
                Task {
                    await profileGalleryViewModel.loadAndUploadImage(userId: userId)
                }
            }
        }
        .onChange(of: user?.userId) { oldId, newId in
            if oldId != newId {
                profileGalleryViewModel.loadUserImagesFromFirestore(for: user)
            }
        }
        .fullScreenCover(item: $selectedIdentifiableURL) { identifiableURL in
            FullScreenImageView(
                imageURLs: profileGalleryViewModel.photoURLs,
                initialIndex: identifiableURL.index ?? 0
            ) {
                selectedIdentifiableURL = nil
            }
        }
    }
}
