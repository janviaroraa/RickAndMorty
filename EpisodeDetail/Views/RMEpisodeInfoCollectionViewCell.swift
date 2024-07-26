//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 23/07/24.
//

import UIKit

class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMEpisodeInfoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateBorderColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateBorderColor()
    }

    private func updateBorderColor() {
        contentView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .secondarySystemBackground
    }

    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {

    }

}
