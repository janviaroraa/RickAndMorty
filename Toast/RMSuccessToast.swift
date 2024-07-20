//
//  RMSuccessToast.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 19/07/24.
//

import UIKit

class RMSuccessToast: PPToastAdaptable {
    override func getTitleColor() -> UIColor {
        UIColor(0, 139, 38, 1)
    }

    override func getBackgroundColor() -> UIColor {
        UIColor(230, 243, 233, 1)
    }
}
