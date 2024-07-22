//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 20/07/24.
//

import Foundation
import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {

    private(set) var type: `Type`
    private(set) var value: String?

    var title: String {
        type.displayTitle
    }

    var iconImage: UIImage? {
        return type.iconImage
    }

    var tintColor: UIColor {
        return type.tintColor
    }

    var displayValue: String {
        if let value {
            if value.isEmpty { return "None" }
            if let date = Self.dateFormatter.date(from: value),
               type == .created {
                return Self.shortDateFormatter.string(from: date)
            }
            return value
        }
        return "None"
    }

    // "yyyy-MM-dd'T'HH:mm:ss.SSSSZ": ISO 8601 format
    // DateFormatter: Expensive operation in terms of performance overhead, that's why they are being created as static.
    // Website for Date Format: https://www.nsdateformatter.com/
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()

    enum `Type` {
        case status
        case species
        case type
        case gender
        case origin
        case location
        case episodeCount
        case created

        var displayTitle: String {
            switch self {
            case .status: return "Status"
            case .species: return "Species"
            case .type: return "Type"
            case .gender: return "Gender"
            case .origin: return "Origin"
            case .location: return "Location"
            case .episodeCount: return "Episode Count"
            case .created: return "Creation Date"
            }
        }

        var iconImage: UIImage? {
            switch self {
            case .status: return UIImage(systemName: "person.fill.checkmark")
            case .species: return UIImage(systemName: "leaf.fill")
            case .type: return UIImage(systemName: "tag.fill")
            case .gender: return UIImage(systemName: "person.2.fill")
            case .origin: return UIImage(systemName: "globe")
            case .location: return UIImage(systemName: "location.fill")
            case .episodeCount: return UIImage(systemName: "film.fill")
            case .created: return UIImage(systemName: "calendar")
            }
        }

        var tintColor: UIColor {
            switch self {
            case .status: return .systemBlue
            case .species: return .systemGreen
            case .type: return .systemIndigo
            case .gender: return .systemPink
            case .origin: return .systemTeal
            case .location: return .systemYellow
            case .episodeCount: return .systemOrange
            case .created: return .systemBrown
            }
        }
    }

    init(type: `Type`, value: String? = "None") {
        self.value = value
        self.type = type
    }
}
