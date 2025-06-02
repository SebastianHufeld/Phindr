//
//  ImgurAPIRepository.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 15.05.25.
//

import Foundation

class ImgurAPIRepository {
    private let clientID = APIKeys.imgurApiKey.rawValue
    private let apiURL = URL(string: "https://api.imgur.com/3/image")!
    
    struct ImgurResponse: Decodable {
        struct Data: Decodable {
            let link: URL
            let deletehash: String?
        }
        let data: Data
        let success: Bool
    }
    
    func uploadImage(_ imageData: Data) async throws -> ImgurResponse {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "image": imageData.base64EncodedString(),
            "type": "base64",
            "title": "Phinder Profile Image",
            "description": "Uploaded from Phinder App"
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "ImgurError",
                          code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                          userInfo: [NSLocalizedDescriptionKey: "Server-Fehler beim Bildupload"])
        }
        
        let decoded = try JSONDecoder().decode(ImgurResponse.self, from: data)
        
        guard decoded.success else {
            throw NSError(domain: "ImgurError",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Upload fehlgeschlagen – Antwort ungültig"])
        }
        
        return decoded
    }
}
