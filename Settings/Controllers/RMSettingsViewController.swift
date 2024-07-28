//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

final class RMSettingsViewController: UIViewController {

    private var viewModel: RMSettingsViewViewModal?

    private var settingsView: UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        registerViewModel()
        addViews()
        layoutConstraints()
    }

    private func addViews() {
        addSwiftUIController()
        guard let settingsView else { return }
        view.addSubview(settingsView.view)
    }

    private func layoutConstraints() {
        guard let settingsView else { return }
        NSLayoutConstraint.activate([
            settingsView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func addSwiftUIController() {
        let settingsView = UIHostingController(
            rootView:
                RMSettingsView(
                    viewModel: RMSettingsViewViewModal(cellViewModels: RMSettingsOptions.allCases.compactMap({
                        return RMSettingsCellViewViewModal(type: $0) { [weak self] option in
                            self?.handleTap(for: option)
                        }
                    }))
                )
        )

        settingsView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(settingsView)
        settingsView.didMove(toParent: self)

        self.settingsView = settingsView
    }

    private func registerViewModel() {
        viewModel = RMSettingsViewViewModal(cellViewModels: RMSettingsOptions.allCases.compactMap({
            return RMSettingsCellViewViewModal(type: $0) { option in

            }
        }))
    }

    private func handleTap(for option: RMSettingsOptions) {
        guard Thread.current.isMainThread else { return }

        if let url = option.targetUrl {
            // Show website
            let vc = SFSafariViewController(url: url)
            // Pushing a safari vc doesn't actually work, so you need to present it instead
            present(vc, animated: true)
        } else if option == .rateApp {
            // Show prompt
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
            /* 
             In this app, if you click `Rate App` again and again, then it'll prompt the SKStoreReviewController every time, but in a real-time application, we generally don't show it again if user has already clicked on `Not Now`.
             So, in that case we can open up the app store directly for user to give the ratings.
             */
        }
    }
}
