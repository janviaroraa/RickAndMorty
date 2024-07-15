//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import UIKit

final class RMCharacterViewController: UIViewController {

    private var characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        layoutConstraints()
    }

    private func addViews() {
        view.addSubview(characterListView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
