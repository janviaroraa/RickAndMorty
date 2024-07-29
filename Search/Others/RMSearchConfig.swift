//
//  RMSearchConfig.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 23/07/24.
//

import Foundation

struct RMSearchConfig {

    enum `Type` {
        case character // name | status | gender
        case location // name | type
        case episode // name

        var title: String {
            switch self {
            case .character: return "Search Characters"
            case .location: return "Search Locations"
            case .episode: return "Search Episodes"
            }
        }

        var endpoint: RMEndPoint {
            switch self {
            case .character: return .character
            case .location: return .location
            case .episode: return .episode
            }
        }
    }

    let type: `Type`
}
