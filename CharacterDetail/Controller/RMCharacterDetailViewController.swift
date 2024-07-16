//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 15/07/24.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {

    private let detailView = RMCharacterDetailView()

    private var viewModel: RMCharacterDetailViewViewModel

    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.characterName
    }
}
