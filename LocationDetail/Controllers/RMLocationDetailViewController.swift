//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

final class RMLocationDetailViewController: UIViewController {

    private var viewModel: RMLocationDetailViewViewModel?

    private let detailView = RMLocationDetailView()

    init(location: RMLocation) {
        self.viewModel = RMLocationDetailViewViewModel(endpointURL: URL(string: location.url ?? ""))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBarItem()
        addViews()
        layoutConstraints()
        detailView.delegate = self
        viewModel?.delegate = self
        viewModel?.fetchLocationData()
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

extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate {
    func didFetchLocationDetails() {
        guard let viewModel else { return }
        detailView.configure(with: viewModel)
    }
}

extension RMLocationDetailViewController: RMLocationDetailViewDelegate {
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        navigationController?.pushViewController(vc, animated: true)
    }
}
