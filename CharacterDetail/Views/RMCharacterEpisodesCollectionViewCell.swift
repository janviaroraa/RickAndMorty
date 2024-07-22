//
//  RMCharacterEpisodesCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 20/07/24.
//

import UIKit

final class RMCharacterEpisodesCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterEpisodesCollectionViewCell"

    private lazy var stackView: UIStackView = {
        let stk = UIStackView()
        stk.translatesAutoresizingMaskIntoConstraints = false
        stk.axis = .vertical
        stk.distribution = .equalSpacing
        stk.layer.masksToBounds = true
        stk.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stk.isLayoutMarginsRelativeArrangement = true
        return stk
    }()

    private lazy var episodeSeasonLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18)
        lbl.textAlignment = .center
        lbl.textColor = .label
        return lbl
    }()

    private lazy var episodeNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textAlignment = .center
        lbl.textColor = .label
        return lbl
    }()

    private lazy var episodeAirDateLabel: UILabel = {
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        episodeSeasonLabel.text = nil
        episodeNameLabel.text = nil
        episodeAirDateLabel.text = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateBorderColor()
    }

    private func addViews() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        updateBorderColor()
        contentView.addSubviews(stackView)
        stackView.addArrangedSubview(episodeSeasonLabel)
        stackView.addArrangedSubview(episodeNameLabel)
        stackView.addArrangedSubview(episodeAirDateLabel)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    private func updateBorderColor() {
        contentView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        contentView.backgroundColor = .secondarySystemBackground
    }

    func configure(with viewModel: RMCharacterEpisodesCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            DispatchQueue.main.async {
                self?.episodeSeasonLabel.text = data.episode
                self?.episodeNameLabel.text = data.name?.uppercased()
                self?.episodeAirDateLabel.text = "Aired on: \(String(describing: data.air_date ?? "N/A"))"
            }
        }
        viewModel.fetchEpisode()
    }
}
