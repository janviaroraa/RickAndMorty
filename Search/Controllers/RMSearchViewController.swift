//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 23/07/24.
//

import UIKit

final class RMSearchViewController: UIViewController {

    private var searchView: RMSearchView?
    private var viewModal: RMSearchViewViewModal?

    init(config: RMSearchConfig) {
        self.viewModal = .init(config: config)
        self.searchView = RMSearchView(frame: .zero, viewModal: .init(config: config))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModal?.config.type.title
        configureNavBarItem()
        addViews()
        layoutConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView?.presentKeyboard()
    }

    private func configureNavBarItem() {
        let barButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    private func addViews() {
        guard let searchView else { return }
        view.addSubview(searchView)
    }

    private func layoutConstraints() {
        guard let searchView else { return }
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapExecuteSearch() {
        viewModal?.executeSearch()
    }
}
