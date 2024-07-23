//
//  RMEndPoint.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import Foundation

// Conforming it to hashable so that we can use RMEndpoint in RMAPICacheManager's cacheDictionary as the key.
@frozen enum RMEndPoint: String, Hashable, CaseIterable {
    case character
    case location
    case episode
}
