//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import UIKit

final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBarItem()
    }

    private func configureNavBarItem() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
