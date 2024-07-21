//
//  RMCharacterEpisodesCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 20/07/24.
//

import UIKit

final class RMCharacterEpisodesCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterEpisodesCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        layoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func addViews() {

    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([

        ])
    }

    func configure(with viewModel: RMCharacterEpisodesCollectionViewCellViewModel) {

    }
}
