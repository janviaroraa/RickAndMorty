//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 20/07/24.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterInfoCollectionViewCell"

    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.quaternaryLabel.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = UIImage(systemName: "globe.americas")
        return imgView
    }()

    private var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textAlignment = .center
        lbl.textColor = .label
        return lbl
    }()

    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        layoutConstraints()
        updateBorderColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
        iconImageView.tintColor = .label
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateBorderColor()
    }

    private func addViews() {
        contentView.layer.cornerRadius = 8
        updateBorderColor()
        contentView.addSubview(containerView)
        containerView.addSubviews(iconImageView, titleContainerView, descriptionLabel)
        titleContainerView.addSubviews(titleLabel)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),

            titleContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),

            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),

            iconImageView.heightAnchor.constraint(equalToConstant: 35),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 20),
            iconImageView.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: -10),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),


            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

        ])
    }

    private func updateBorderColor() {
        containerView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        contentView.backgroundColor = .tertiarySystemBackground
        titleContainerView.backgroundColor = .secondarySystemBackground
    }

    func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title.uppercased()
        descriptionLabel.text = viewModel.displayValue
        iconImageView.image = viewModel.iconImage
        iconImageView.tintColor = viewModel.tintColor
    }
}
