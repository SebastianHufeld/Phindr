//
//  IdentifiableURL.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 22.05.25.
//

import Foundation

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let urlString: String
    let index: Int? 
        
        init(urlString: String, index: Int? = nil) {
            self.urlString = urlString
            self.index = index
        }
}
