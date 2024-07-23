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
    }

    private func registerViewModel() {
        viewModel = RMEpisodeDetailViewViewModel(endpointURL: url)
    }
}
