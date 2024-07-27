//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 22/07/24.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {

    private let url: URL?
    private var viewModel: RMEpisodeDetailViewViewModel?

    private let detailView = RMEpisodeDetailView()

    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // By not setting this property, you may face lagging in the screen because in that case view's backgroundColor will be nil.
        view.backgroundColor = .systemBackground

        registerViewModel()
        configureNavBarItem()
        addViews()
        layoutConstraints()
        detailView.delegate = self
        viewModel?.delegate = self
        viewModel?.fetchEpisodeData()
    }

    private func registerViewModel() {
        viewModel = RMEpisodeDetailViewViewModel(endpointURL: url)
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

extension RMEpisodeDetailViewController: RMEpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        guard let viewModel else { return }
        detailView.configure(with: viewModel)
    }
}

extension RMEpisodeDetailViewController: RMEpisodeDetailViewDelegate {
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        navigationController?.pushViewController(vc, animated: true)
    }
}
