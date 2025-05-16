//
//  ImgurUploadResponse.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 15.05.25.
//

import Foundation

struct ImgurUploadResponse: Codable {
    struct ImgurData: Codable {
        let id: String
        let deletehash: String
        let link: URL
    }

    let status: Int
    let success: Bool
    let data: ImgurData
}
