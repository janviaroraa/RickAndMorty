//
//  RMSettingsCellViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 27/07/24.
//

import UIKit

struct RMSettingsCellViewViewModal: Identifiable {

    let type: RMSettingsOptions
    let onTapHandler: ((RMSettingsOptions)-> Void)
    let id = UUID()

    var image: UIImage? {
        return type.iconImage?.withTintColor(type.tintColor, renderingMode: .alwaysOriginal)
    }

    var title: String {
        return type.displayTitle
    }

    var tintColor: UIColor {
        return type.tintColor
    }

    init(type: RMSettingsOptions, onTapHandler: @escaping (RMSettingsOptions)-> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}
