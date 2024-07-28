//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

final class RMSearchInputView: UIView {

    private var viewModal: RMSearchInputViewViewModal? {
        didSet {
            guard let viewModal, viewModal.hasDynamicOptions else { return }
            let options = viewModal.options
            createOptionsSelectionview(options: options)
        }
    }

    private lazy var searchBar: UISearchBar = {
        let searchB = UISearchBar()
        searchB.translatesAutoresizingMaskIntoConstraints = false
        searchB.backgroundImage = UIImage()
        return searchB
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addViews()
        layoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubviews(searchBar)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func createOptionsSelectionview(options: [RMSearchDynamicOptions]) {
        let stackView = createDynamicStack()

        for item in 0..<options.count {
            let option = options[item]
            let button = createDynamicButton(with: option, tag: item)
            stackView.addArrangedSubview(button)
        }
    }

    private func createDynamicStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true

        addSubviews(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        return stackView
    }

    private func createDynamicButton(with option: RMSearchDynamicOptions, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(option.rawValue, for: .normal)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapOption(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.tag = tag
        return button
    }

    @objc
    private func didTapOption(_ sender: UIButton) {
        guard let viewModal, viewModal.hasDynamicOptions else { return }
        let tag = sender.tag
        let selected = viewModal.options[tag]
        print(selected.rawValue)
    }

    func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }

    func configure(with viewModal: RMSearchInputViewViewModal) {
        self.viewModal = viewModal
        searchBar.placeholder = viewModal.searchPlaceholderText
    }
}

