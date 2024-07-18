//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 18/07/24.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // A reusable collection view doesn't have a contentView
    private func addViews() {
        addSubview(spinner)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 20),
            spinner.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    func startAnimating() {
        spinner.startAnimating()
    }

}
