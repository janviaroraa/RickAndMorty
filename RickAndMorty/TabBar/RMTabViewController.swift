//
//  RMTabViewController.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import UIKit

final class RMTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
    }

    private func setupTabs() {
        let charactersVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()

        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic

        charactersVC.title = "Characters"
        locationVC.title = "Location"
        episodeVC.title = "Episodes"
        settingsVC.title = "Settings"

        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)

        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear "), tag: 4)

        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }

        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }


}

