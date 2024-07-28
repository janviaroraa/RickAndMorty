//
//  RMSearchInputViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import Foundation

struct RMSearchInputViewViewModal {

    private let type: RMSearchConfig.`Type`

    var hasDynamicOptions: Bool {
        switch self.type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }

    var options: [RMSearchDynamicOptions] {
        switch self.type {
        case .character:
            return [.characterGender, .characterStatus]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }

    var searchPlaceholderText: String {
        switch self.type {
        case .character:
            return "Type to search for characters..."
        case .location:
            return "Type to search for a particular location..."
        case .episode:
            return "Type to search for episodes..."
        }
    }

    init(type: RMSearchConfig.`Type`) {
        self.type = type
    }
}
