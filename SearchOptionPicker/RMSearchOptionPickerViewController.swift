//
//  RMSearchOptionPickerViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

class RMSearchOptionPickerViewController: UIViewController {

    private let option: RMSearchDynamicOption
    private let selectionBlock: ((String) -> Void)

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "CustomTableviewCell")
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    init(option: RMSearchDynamicOption, selection: @escaping ((String) -> Void)) {
        self.option = option
        self.selectionBlock = selection
        super.init(nibName: nil, bundle: nil)
        addViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = option.rawValue
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
    }

    private func addViews() {
        view.addSubview(tableView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension RMSearchOptionPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        option.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableviewCell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = option.choices[indexPath.row].uppercased()
        return cell
    }
}

extension RMSearchOptionPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let choice = option.choices[indexPath.row]
        selectionBlock(choice)
        
        UIView.animate(withDuration: 1, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
}
