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
    @Published var photoPickerItem: PhotosPickerItem?
    @Published var selectedImageData: Data?
    @Published var isUploading = false
    @Published var showUploadSheet = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    @Published var isFinishedUploading = false

    private let firestore = Firestore.firestore()
    private let imgurRepository = ImgurAPIRepository()

    func loadAndUploadImage(userId: String) async {
        guard let imageData = selectedImageData else {
            errorMessage = "Kein Bild verfügbar."
            showErrorAlert = true
            return
        }

        isUploading = true
        showUploadSheet = true
        isFinishedUploading = false

        do {
            let response = try await imgurRepository.uploadImage(imageData)
            let imageUrl = response.data.link.absoluteString

            try await firestore
                .collection("users")
                .document(userId)
                .collection("photos")
                .addDocument(data: [
                    "url": imageUrl,
                    "uploadedAt": Timestamp(date: Date())
                ])

            await loadUserImagesFromFirestore(for: userId)
            isFinishedUploading = true
            showUploadSheet = false
            selectedImageData = nil
            photoPickerItem = nil

        } catch {
            errorMessage = "Bild konnte nicht hochgeladen werden: \(error.localizedDescription)"
            showErrorAlert = true
            isUploading = false
            showUploadSheet = false
        }
    }

    func compressImageIfNeeded(_ data: Data, from image: UIImage) -> Data {
        if data.count > 1_000_000 {
            return image.jpegData(compressionQuality: 0.5) ?? data
        } else {
            return data
        }
    }

    func loadUserImagesFromFirestore(for userId: String) async {
        do {
            let snapshot = try await firestore
                .collection("users")
                .document(userId)
                .collection("photos")
                .order(by: "uploadedAt", descending: true)
                .getDocuments()

            let urls = snapshot.documents.compactMap { $0.data()["url"] as? String }
            self.photoURLs = urls
            self.errorMessage = nil
        } catch {
            showError("Fehler beim Laden der Bilder: \(error.localizedDescription)")
        }
    }

    func showError(_ message: String) {
        errorMessage = message
        showErrorAlert = true
    }
    
    func deleteImage(at index: Int, userId: String) {
        guard index >= 0 && index < photoURLs.count else { return }

        let urlToDelete = photoURLs[index]

        firestore
            .collection("users")
            .document(userId)
            .collection("photos")
            .whereField("url", isEqualTo: urlToDelete)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.showError("Fehler beim Löschen: \(error.localizedDescription)")
                    return
                }

                guard let document = snapshot?.documents.first else {
                    self.showError("Bilddokument nicht gefunden.")
                    return
                }

                document.reference.delete { error in
                    if let error = error {
                        self.showError("Fehler beim Löschen: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.photoURLs.remove(at: index)
                        }
                    }
                }
            }
    }
}
