//
//  RMErrorToast.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 19/07/24.
//

import UIKit

class RMErrorToast: PPToastAdaptable {
    override func getTitleColor() -> UIColor {
        .white
    }

    override func getBackgroundColor() -> UIColor {
        .systemRed
    }
}


