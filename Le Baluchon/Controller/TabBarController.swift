//
//  TabBarViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

/// Setup the app tab bar and add a navigation controller to the ViewController of each tabs.
class TabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewcontrollers()
    }

    // MARK: - Setup
    /// Set up the tabBar appearance with standard darkmode compatible colors.
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }

    /// Set up each viewControllers in the TabBar
    /// - SFSymbols are used for icon images.
    private func setupViewcontrollers() {
        let rateIconImage = UIImage(systemName: "arrow.up.arrow.down.circle")!
        let rateViewController = updateTabBarItem(for: ExchangeViewController(),
                                                  title: "Taux de change",
                                                  image: rateIconImage)

        let translateIconImage = UIImage(systemName: "globe")!
        let translationViewController = updateTabBarItem(for: TranslationViewController(),
                                                         title: "Traduction",
                                                         image: translateIconImage)

        let weatherIconImage = UIImage(systemName: "cloud.sun.fill")!
        let weatherViewController = updateTabBarItem(for: WeatherViewController(),
                                                     title: "Météo",
                                                     image: weatherIconImage)
        viewControllers = [rateViewController,
                           translationViewController,
                           weatherViewController]
    }
    /// Adds tab with an icon image and a title.
    /// - Parameters:
    ///   - rootViewController: Name of the ViewController assiciated to the tab
    ///   - title: Title name of the tab
    ///   - image: Name of the image
    /// - Returns: A modified ViewController
    private func updateTabBarItem(for viewController: UIViewController,
                                  title: String,
                                  image: UIImage) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}

