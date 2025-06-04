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
    @State private var showDeleteAlert = false
    @State private var deleteIndex: Int?

    var gridItems: [GridItem] = Array(repeating: .init(.fixed(120), spacing: 2), count: 3)

    var body: some View {
        VStack(spacing: 0) {
            if profileGalleryViewModel.photoURLs.isEmpty {
                Text("Noch keine Bilder vorhanden.")
                    .foregroundColor(.gray)
                    .padding()
            }

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
                    .onLongPressGesture {
                        if isOwnProfile {
                            confirmDeletion(for: index)
                        }
                    }
                }
            }
            .padding(.horizontal, 1)
            .padding(.vertical, 1)
        }
        .onAppear {
            loadPhotos()
        }
        .onChange(of: profileGalleryViewModel.photoPickerItem) {
            guard let item = profileGalleryViewModel.photoPickerItem else { return }

            Task {
                do {
                    let data = try await item.loadTransferable(type: Data.self)

                    if let data, let image = UIImage(data: data) {
                        profileGalleryViewModel.selectedImageData = profileGalleryViewModel.compressImageIfNeeded(data, from: image)

                        if isOwnProfile, let userId = currentUserViewModel.user?.userId {
                            await profileGalleryViewModel.loadAndUploadImage(userId: userId)
                            profileGalleryViewModel.photoPickerItem = nil
                        }
                    } else {
                        profileGalleryViewModel.showError("Kein Bild vorhanden oder nicht lesbar.")
                    }
                } catch {
                    profileGalleryViewModel.showError("Fehler beim Laden des Bildes: \(error.localizedDescription)")
                }
            }
        }
        .onChange(of: user?.userId) { oldId, newId in
            if oldId != newId {
                loadPhotos()
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
        .sheet(isPresented: $profileGalleryViewModel.showUploadSheet) {
            VStack(spacing: 20) {
                if profileGalleryViewModel.isUploading {
                    ProgressView("Bild wird hochgeladen…")
                        .padding()
                } else if profileGalleryViewModel.isFinishedUploading {
                    Text("Upload abgeschlossen")
                        .font(.headline)
                        .padding()
                }
            }
            .background(Color(.systemBackground))
        }
        .alert("Fehler", isPresented: $profileGalleryViewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(profileGalleryViewModel.errorMessage ?? "Ein Fehler ist aufgetreten.")
        }
        .alert("Bild löschen?", isPresented: $showDeleteAlert) {
            Button("Löschen", role: .destructive) {
                if let index = deleteIndex, let userId = currentUserViewModel.user?.userId {
                    Task {
                        profileGalleryViewModel.deleteImage(at: index, userId: userId)
                        loadPhotos()
                    }
                }
            }
            Button("Abbrechen", role: .cancel) {}
        }
    }

    private func loadPhotos() {
        guard let userId = user?.userId else { return }
        Task {
            await profileGalleryViewModel.loadUserImagesFromFirestore(for: userId)
        }
    }

    private func confirmDeletion(for index: Int) {
        deleteIndex = index
        showDeleteAlert = true
    }
}
