//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

final class RMSearchView: UIView {

    private let viewModal: RMSearchViewViewModal

    private let emptyStateView = RMNoSearchStateView()
    private let searchInputView = RMSearchInputView()

    init(frame: CGRect, viewModal: RMSearchViewViewModal) {
        self.viewModal = viewModal
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addViews()
        layoutConstraints()
        searchInputView.configure(with: .init(type: viewModal.config.type))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubviews(searchInputView, emptyStateView)
    }

    private func layoutConstraints() {
        var optionsHeight: CGFloat = 0
        switch viewModal.config.type {
        case .character, .location:
            optionsHeight = 40
        case .episode:
            optionsHeight = 0
        }

        NSLayoutConstraint.activate([
            // No results View
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: 100),
            emptyStateView.widthAnchor.constraint(equalToConstant: 100),

            // Input Search View
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: 60 + optionsHeight)
        ])
    }

    func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

extension RMSearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemIndigo
        return cell
    }
}

extension RMSearchView: UICollectionViewDelegateFlowLayout {

}

extension RMSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
