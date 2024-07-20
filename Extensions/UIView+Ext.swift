//
//  UIView+Ext.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach ({ addSubview($0) })
    }

    func makeRounded(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
