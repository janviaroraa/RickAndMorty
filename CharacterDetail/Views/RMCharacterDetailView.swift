//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 15/07/24.
//

import UIKit

/// View for single character info.
final class RMCharacterDetailView: UIView {

    var detailCollectionView: UICollectionView?
    private let viewModel: RMCharacterDetailViewViewModel

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
        addViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        let detailCollectionView = createCollectionView()
        self.detailCollectionView = detailCollectionView
        addSubviews(detailCollectionView, spinner)
    }

    private func layoutConstraints() {
        guard let detailCollectionView else {
            RMErrorToast(withText: "Trouble getting character details").show()
            return
        }

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),

            detailCollectionView.topAnchor.constraint(equalTo: topAnchor),
            detailCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Compositional Collection Layout's Section Configuration

extension RMCharacterDetailView {
    private func createCollectionView() -> UICollectionView {
        // Sometimes we need to create complex layouts for apps with different sections that look and behave differently, just like your LEGO city.
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createSection(for: sectionIndex)
        }

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RMCharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier)
        cv.register(RMCharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier)
        cv.register(RMCharacterEpisodesCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodesCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch viewModel.sections[sectionIndex] {
        case .photo:
            viewModel.createPhotoSectionLayout()
        case .information:
            viewModel.createInfoSectionLayout()
        case .episodes:
            viewModel.createEpisodesSectionLayout()
        }
    }
}
