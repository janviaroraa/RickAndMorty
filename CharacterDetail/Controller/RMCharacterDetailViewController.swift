//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 15/07/24.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {

    private let detailView: RMCharacterDetailView

    private var viewModel: RMCharacterDetailViewViewModel

    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.characterName
        addViews()
        layoutConstraints()
        configureNavBarItem()
        detailView.detailCollectionView?.delegate = self
        detailView.detailCollectionView?.dataSource = self
    }

    private func configureNavBarItem() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }

    private func addViews() {
        view.addSubview(detailView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapShare() {
        
    }
}

extension RMCharacterDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier, for: indexPath) as? RMCharacterPhotoCollectionViewCell else { fatalError() }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier, for: indexPath) as? RMCharacterInfoCollectionViewCell else { fatalError() }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodesCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodesCollectionViewCell else { fatalError() }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
}

extension RMCharacterDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
            break
        case .episodes:
            let episodes = self.viewModel.episodes
            let selectedEpisode = episodes[indexPath.row]
            
            let vc = RMEpisodeDetailViewController(url: URL(string: selectedEpisode))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
