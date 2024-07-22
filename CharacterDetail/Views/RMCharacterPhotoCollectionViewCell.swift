//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 20/07/24.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterPhotoCollectionViewCell"

    private lazy var stackView: UIStackView = {
        let stk = UIStackView()
        stk.translatesAutoresizingMaskIntoConstraints = false
        stk.axis = .vertical
        stk.layer.borderColor = UIColor.quaternaryLabel.cgColor
        stk.layer.cornerRadius = 20
        stk.layer.borderWidth = 1
        stk.spacing = 4
        stk.layer.masksToBounds = true
        return stk
    }()

    private lazy var characterImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

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
        characterImageView.image = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateBorderColor()
    }

    private func addViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(characterImageView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    private func updateBorderColor() {
        stackView.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }

    func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.characterImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    RMErrorToast(withText: error.localizedDescription).show()
                }
            }
        }
    }
}
