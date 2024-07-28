//
//  RMSettingsOptions.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 27/07/24.
//

import UIKit

enum RMSettingsOptions: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewMedium
    case github
    case linkedin
    case viewCode

    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return nil
        case .terms:
            return URL(string: "https://iosacademy.io/terms")
        case .privacy:
            return URL(string: "https://iosacademy.io/privacy")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation/")
        case .viewMedium:
            return URL(string: "https://medium.com/@janviarora")
        case .viewCode:
            return URL(string: "https://github.com/janviaroraa/RickAndMorty")
        case .github:
            return URL(string: "https://github.com/janviaroraa")
        case .linkedin:
            return URL(string: "https://www.linkedin.com/in/janvi-arora-ja06660/")
        }
    }

    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewMedium:
            return "Medium Profile"
        case .viewCode:
            return "App Code"
        case .github:
            return "GitHub Profile"
        case .linkedin:
            return "LinkedIn Profile"
        }
    }

    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "envelope.fill")
        case .terms:
            return UIImage(systemName: "doc.text.fill")
        case .privacy:
            return UIImage(systemName: "lock.fill")
        case .apiReference:
            return UIImage(systemName: "book.fill")
        case .viewMedium:
            return UIImage(systemName: "newspaper.fill")
        case .viewCode:
            return UIImage(systemName: "chevron.left.slash.chevron.right")
        case .github:
            return UIImage(systemName: "person.crop.circle.fill")
        case .linkedin:
            return UIImage(systemName: "network")
        }
    }

    var tintColor: UIColor {
        switch self {
        case .rateApp:
            return .systemYellow
        case .contactUs:
            return .systemBlue
        case .terms:
            return .systemGray
        case .privacy:
            return .systemRed
        case .apiReference:
            return .systemGreen
        case .viewMedium:
            return .systemTeal
        case .viewCode:
            return .systemOrange
        case .github:
            return .systemIndigo
        case .linkedin:
            return .systemBlue
        }
    }
}
