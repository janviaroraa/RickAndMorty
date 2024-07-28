//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

class RMLocationTableViewCell: UITableViewCell {
    static let identifier = "RMLocationTableViewCell"

    private lazy var stackView: UIStackView = {
        let stk = UIStackView()
        stk.translatesAutoresizingMaskIntoConstraints = false
        stk.axis = .vertical
        stk.spacing = 8
        stk.layer.masksToBounds = true
        stk.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stk.isLayoutMarginsRelativeArrangement = true
        return stk
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.textColor = .label
        return lbl
    }()

    private let typeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()

    private let dimensionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        addViews()
        layoutConstraints()
        setupLayer()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupLayer()
    }

    private func setupLayer() {
        stackView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 8
        stackView.backgroundColor = .secondarySystemBackground
    }

    private func addViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(dimensionLabel)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    func configure(with viewModal: RMLocationTableViewCellViewModal) {
        nameLabel.text = viewModal.name
        typeLabel.text = "Type: \(viewModal.type)"
        dimensionLabel.text = "Dimension: \(viewModal.dimension)"
    }

}
