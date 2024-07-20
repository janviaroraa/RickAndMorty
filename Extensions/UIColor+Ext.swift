//
//  UIColor+Ext.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 19/07/24.
//

import UIKit

extension UIColor {

    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha * 1.0)
    }
}
