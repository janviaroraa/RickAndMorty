//
//  RMNoSearchStateView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

final class RMNoSearchStateView: UIView {

    private var viewModal: RMNoSearchStateViewViewModal?

    private lazy var emptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.textColor = .label
        return lbl
    }()

    private lazy var descLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()

    private lazy var imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .scaleAspectFit
        imgV.tintColor = .systemBlue
        return imgV
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // This view is made hidden at initial & will be displayed in case no search results are found for the entered query.
        isHidden = true

        registerViewModal()
        addViews()
        layoutConstraints()
        configureData()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerViewModal() {
        viewModal = RMNoSearchStateViewViewModal()
    }

    private func addViews() {
        addSubviews(imageView, emptyLabel, descLabel)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.bottomAnchor.constraint(equalTo: emptyLabel.topAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            descLabel.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 10),
            descLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func configureData() {
        emptyLabel.text = viewModal?.title
        imageView.image = viewModal?.image
        descLabel.text = viewModal?.desc
    }
}
