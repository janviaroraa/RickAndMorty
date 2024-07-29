//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 29/07/24.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

final class RMSearchResultsView: UIView {

    weak var delegate: RMSearchResultsViewDelegate?

    private var results: RMSearchResultsRepresentable? {
        didSet {
            processResults()
        }
    }

    private var locationsCellViewModals = [RMLocationTableViewCellViewModal]()
    private var collectionViewCellViewModals = [any Hashable]()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true

        cv.register(
            RMCharacterEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifer
        )
        cv.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier
        )
        cv.register(
            RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )

        return cv
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        tv.isHidden = true
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubviews(tableView, collectionView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func processResults() {
        guard let results else { return }

        switch results {
        case .characters(let viewModals):
            setupCollectionView(viewModals: viewModals)
        case .locations(let viewModals):
            setupTableView(viewModals: viewModals)
        case .episodes(let viewModals):
            setupCollectionView(viewModals: viewModals)
        }
    }

    private func setupCollectionView(viewModals: [any Hashable]) {
        collectionView.isHidden = false
        tableView.isHidden = true

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewCellViewModals = viewModals
        collectionView.reloadData()
    }

    private func setupTableView(viewModals: [RMLocationTableViewCellViewModal]) {
        tableView.isHidden = false
        collectionView.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        locationsCellViewModals = viewModals
        tableView.reloadData()
    }

    func configure(with results: RMSearchResultsRepresentable) {
        self.results = results
    }
}

extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationsCellViewModals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier, for: indexPath) as? RMLocationTableViewCell else { fatalError() }
        cell.configure(with: locationsCellViewModals[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

extension RMSearchResultsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewCellViewModals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModal = collectionViewCellViewModals[indexPath.row]

        if let viewModal = viewModal as? RMCharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else { fatalError() }
            cell.configure(with: viewModal)
            return cell
        } else if let viewModal = viewModal as? RMCharacterEpisodeCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifer, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { fatalError() }
            cell.configure(with: viewModal)
            return cell
        } else {
            fatalError("Unsupported")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModal = collectionViewCellViewModals[indexPath.row]

        if viewModal is RMCharacterCollectionViewCellViewModel {
            let bounds = UIScreen.main.bounds
            let width = (bounds.width - 30) / 2
            return CGSize(
                width: width,
                height: width * 1.5
            )
        } else if viewModal is RMCharacterEpisodeCollectionViewCellViewModel {
            let bounds = collectionView.bounds
            let width = bounds.width-20
            return CGSize(
                width: width,
                height: 100
            )
        } else {
            return .zero
        }
    }
}
