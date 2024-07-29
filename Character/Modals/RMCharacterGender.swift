//
//  RMCharacterGender.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import Foundation

enum RMCharacterGender: String, Codable, RMSearchOptionProtocol {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case `unknown`

    static var allValues: [String] {
        return [self.male.rawValue, self.female.rawValue, self.unknown.rawValue, self.genderless.rawValue]
    }
}
