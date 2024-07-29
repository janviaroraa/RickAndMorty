//
//  RMSearchDynamicOption.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import Foundation

protocol RMSearchOptionProtocol: RawRepresentable where RawValue == String {
    static var allValues: [String] { get }
}

enum RMSearchDynamicOption: String {
    case characterGender = "Gender"
    case characterStatus = "Status"
    case locationType = "Location Type"

    var queryArguments: String {
        switch self {
        case .characterGender: return "gender"
        case .characterStatus: return "status"
        case .locationType: return "type"
        }
    }

    var choices: [String] {
        switch self {
        case .characterGender: return RMCharacterGender.allValues
        case .characterStatus: return RMCharacterStatus.allValues
        case .locationType: return RMLocationType.allValues
        }
    }
}
