//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

class RMCharacterCollectionViewCell: UICollectionViewCell {

    static let identifier = "RMCharacterCollectionViewCellIdentifier"

    private lazy var stackView: UIStackView = {
        let stk = UIStackView()
        stk.translatesAutoresizingMaskIntoConstraints = false
        stk.axis = .vertical
        stk.layer.borderColor = UIColor.systemGray4.cgColor
        stk.layer.cornerRadius = 20
        stk.layer.borderWidth = 1
        stk.spacing = 4
        stk.layer.masksToBounds = true
        stk.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stk.isLayoutMarginsRelativeArrangement = true
        return stk
    }()

    private lazy var characterImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    private lazy var characterNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textAlignment = .center
        lbl.textColor = .label
        return lbl
    }()

    private lazy var characterStatusLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.textColor = .secondaryLabel
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = false
        setupShadow()
        addViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        characterNameLabel.text = nil
        characterStatusLabel.text = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupShadow()
    }

    private func setupShadow() {
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
    }

    private func addViews() {
        contentView.addSubviews(stackView)
        stackView.addArrangedSubview(characterImageView)
        stackView.addArrangedSubview(characterNameLabel)
        stackView.addArrangedSubview(characterNameLabel)
        stackView.addArrangedSubview(characterStatusLabel)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        characterNameLabel.text = viewModel.characterName
        characterStatusLabel.text = viewModel.charcterStatusText

        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.characterImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
