//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ inputView: RMSearchView, didSelect option: RMSearchDynamicOption)
    func rmSearchView(_ inputView: RMSearchView, didSelect location: RMLocation)
}

final class RMSearchView: UIView {

    private let viewModal: RMSearchViewViewModal
    weak var delegate: RMSearchViewDelegate?

    private let noResultsStateView = RMNoSearchStateView()
    private let searchInputView = RMSearchInputView()
    private let searchResultsView = RMSearchResultsView()

    init(frame: CGRect, viewModal: RMSearchViewViewModal) {
        self.viewModal = viewModal
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addViews()
        layoutConstraints()
        searchInputView.configure(with: .init(type: viewModal.config.type))
        searchInputView.delegate = self
        setupHandlers(viewModal: viewModal)
        searchResultsView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubviews(searchInputView, noResultsStateView, searchResultsView)
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
            noResultsStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultsStateView.heightAnchor.constraint(equalToConstant: 100),
            noResultsStateView.widthAnchor.constraint(equalToConstant: 100),

            // Input Search View
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: 60 + optionsHeight),

            // Results View
            searchResultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor, constant: 10),
            searchResultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchResultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchResultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func presentKeyboard() {
        searchInputView.presentKeyboard()
    }

    private func setupHandlers(viewModal: RMSearchViewViewModal) {
        viewModal.registerOptionChangeblock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }

        viewModal.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.searchResultsView.configure(with: results)
                self?.noResultsStateView.isHidden = true
                self?.searchResultsView.isHidden = false
            }
        }

        viewModal.noSearchResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsStateView.isHidden = false
                self?.searchResultsView.isHidden = true
            }
        }
    }
}

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelect option: RMSearchDynamicOption) {
        delegate?.rmSearchView(self, didSelect: option)
    }

    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModal.set(query: text)
    }

    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModal.executeSearch()
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

extension RMSearchView: RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let selectedLocation = viewModal.locationsSearchResult(at: index) else { return }
        delegate?.rmSearchView(self, didSelect: selectedLocation)
    }
}

