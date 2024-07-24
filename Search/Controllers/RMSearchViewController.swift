//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 23/07/24.
//

import UIKit

final class RMSearchViewController: UIViewController {

    private let config: RMSearchConfig

    init(config: RMSearchConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
    }
}
