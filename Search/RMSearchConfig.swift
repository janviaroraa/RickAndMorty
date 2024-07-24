//
//  RMSearchConfig.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 23/07/24.
//

import Foundation

struct RMSearchConfig {

    enum `Type` {
        case character
        case location
        case episode
    }

    let type: `Type`
}
