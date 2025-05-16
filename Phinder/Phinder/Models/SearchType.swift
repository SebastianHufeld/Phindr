//
//  SearchType.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 14.05.25.
//

import Foundation

enum SearchType: String, CaseIterable, Identifiable {
    case model = "Model"
    case fotograf = "Fotograf"
    case studio = "Studio"

    var id: String { self.rawValue }
}
