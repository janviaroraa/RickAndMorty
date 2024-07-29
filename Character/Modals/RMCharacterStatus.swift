//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import Foundation

enum RMCharacterStatus: String, Codable, RMSearchOptionProtocol {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown`

    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }

    static var allValues: [String] {
        return [self.alive.text, self.dead.rawValue, self.unknown.rawValue]
    }
}
