//
//  RMLocationType.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import Foundation

enum RMLocationType: String, RMSearchOptionProtocol {
    case planet = "Planet"
    case cluster = "Cluster"
    case spaceStation = "Space Station"
    case microverse = "Microverse"
    case tv = "TV"
    case resort = "Resort"
    case fantasyTown = "Fantasy Town"
    case dream = "Dream"
    case custom = "Custom"

    static var allValues: [String] {
        return [self.planet.rawValue, self.cluster.rawValue, self.spaceStation.rawValue, self.microverse.rawValue, self.tv.rawValue, self.resort.rawValue, self.fantasyTown.rawValue, self.dream.rawValue, self.custom.rawValue]
    }
}
