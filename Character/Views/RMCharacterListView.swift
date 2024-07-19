//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelect characeter: RMCharacter)
}

final class RMCharacterListView: UIView {

    private var viewModel: RMCharacterListViewViewModal?
    weak var delegate: RMCharacterListViewDelegate?

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        cv.alpha = 0
        cv.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier)
        cv.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        registerViewModel()
        addViews()
        layoutConstraints()
        spinner.startAnimating()
        viewModel?.delegate = self
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
    }
}

extension RMCharacterListView: RMCharacterListViewViewModalProtocol {
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Load only for the first initial fetch
        UIView.animate(withDuration: 1) {
            self.collectionView.alpha = 1
        }
    }

    func didLoadMoreCharacters(newResults: [RMCharacter]) {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates {
                let originalCount = self.viewModel?.characters.count ?? 0
                self.viewModel?.appendCharacters(newResults: newResults)

                let total = originalCount + newResults.count

                let indexPathsToAdd: [IndexPath] = Array(originalCount..<(total)).compactMap ({
                    return IndexPath(row: $0, section: 0)
                })
                self.collectionView.insertItems(at: indexPathsToAdd)
            }
        }
    }

    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self, didSelect: character)
    }
}
