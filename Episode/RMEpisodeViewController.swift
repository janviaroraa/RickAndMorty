//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import UIKit

final class RMEpisodeViewController: UIViewController {

    private var episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBarItem()
        addViews()
        layoutConstraints()
        episodeListView.delegate = self
    }

    private func configureNavBarItem() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    private func addViews() {
        view.addSubview(episodeListView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RMEpisodeViewController: RMEpisodeListViewProtocol {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let vc = RMEpisodeDetailViewController(url: URL(string: episode.url ?? ""))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
