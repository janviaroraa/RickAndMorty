//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

final class RMCharacterListView: UIView {

    private var viewModel: RMCharacterListViewViewModal?

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        cv.alpha = 0
        cv.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier)
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        registerViewModel()
        addViews()
        layoutConstraints()
        spinner.startAnimating()
        viewModel?.fetchCharacters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerViewModel() {
        viewModel = RMCharacterListViewViewModal()
    }

    private func addViews() {
        setupCollectionView()
        addSubviews(collectionView, spinner)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.spinner.stopAnimating()
            self.collectionView.isHidden = false
            UIView.animate(withDuration: 1) {
                self.collectionView.alpha = 1
            }
        }
    }
}
