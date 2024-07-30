//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import UIKit

final class RMLocationViewController: UIViewController {

    private var viewModal: RMLocationViewViewModal?

    private let locationView = RMLocationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBarItem()
        addViews()
        layoutConstraints()
        registerViewModal()
        locationView.delegate = self
        viewModal?.delegate = self
        viewModal?.fetchLocations()
    }

    private func registerViewModal() {
        viewModal = RMLocationViewViewModal()
    }

    private func configureNavBarItem() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    private func addViews() {
        view.addSubviews(locationView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RMLocationViewController: RMLocationViewViewModalDelegate {
    func didFetchInitialLocations() {
        guard let viewModal else { return }
        DispatchQueue.main.async {
            self.locationView.configure(with: viewModal)
        }
    }

    func didLoadMoreLocations(with newIndexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            
        }
    }
}

extension RMLocationViewController: RMLocationViewDelegate {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
