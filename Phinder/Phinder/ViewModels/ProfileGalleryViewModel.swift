//
//  ProfileGalleryViewModel.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 22.05.25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import UIKit

@MainActor
class ProfileGalleryViewModel: ObservableObject {
    @Published var photoURLs: [String] = []
    @Published var photoPickerItem: PhotosPickerItem? {
        didSet {
            Task {
                if let item = photoPickerItem {
                    do {
                        if let data = try await item.loadTransferable(type: Data.self) {
                            self.selectedImageData = compressImageIfNeeded(data)
                        }
                    } catch {
                        self.errorMessage = "Bild konnte nicht geladen werden: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    @Published var selectedImageData: Data?
    @Published var isUploading = false
    @Published var errorMessage: String?

    let imgurRepository = ImgurAPIRepository()

    func loadAndUploadImage(userId: String) async {
        guard let imageData = selectedImageData else {
            errorMessage = "Kein Bild ausgewählt."
            return
        }

        isUploading = true
        errorMessage = nil
        defer { isUploading = false }

        do {
            let response = try await imgurRepository.uploadImage(imageData)

            let imageURL = response.data.link.absoluteString

            let photoData: [String: Any] = [
                "url": imageURL,
                "uploadedAt": FieldValue.serverTimestamp()
            ]

            try await Task.detached {
                try await Firestore.firestore()
                    .collection("users")
                    .document(userId)
                    .collection("photos")
                    .addDocument(data: photoData)
            }.value

            await MainActor.run {
                self.photoURLs.append(imageURL)
                self.selectedImageData = nil
                self.photoPickerItem = nil
            }

        } catch {
            await MainActor.run {
                self.errorMessage = "Upload fehlgeschlagen: \(error.localizedDescription)"
                print("Upload Error: \(error)")
            }
        }
    }

    func compressImageIfNeeded(_ data: Data) -> Data {
        guard data.count > 1_000_000, let uiImage = UIImage(data: data) else { return data }
        return uiImage.jpegData(compressionQuality: 0.5) ?? data
    }

    func loadUserImagesFromFirestore(for user: User?) {
        guard let userId = user?.userId else {
            self.errorMessage = "Benutzer-ID zum Laden der Bilder fehlt."
            return
        }
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("photos")
            .order(by: "uploadedAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Fehler beim Laden der Benutzerbilder: \(error.localizedDescription)"
                        print("Firestore Image Load Error: \(error)")
                    }
                    return
                }

                guard let documents = snapshot?.documents else {
                    DispatchQueue.main.async {
                        self.photoURLs = []
                        print("Keine Bilder in der Unterkollektion 'photos' gefunden.")
                    }
                    return
                }

                let urls = documents.compactMap { doc -> String? in
                    return doc.data()["url"] as? String
                }

                DispatchQueue.main.async {
                    self.photoURLs = urls
                    self.errorMessage = nil
                }
            }
    }
}
