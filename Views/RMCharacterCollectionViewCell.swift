//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

class RMCharacterCollectionViewCell: UICollectionViewCell {

    static let identifier = "RMCharacterCollectionViewCellIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        
    }
}
