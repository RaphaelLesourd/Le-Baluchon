//
//  TabBarViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

/// Setup the app tab bar and add a navigation controller to the ViewController of each tabs.
class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewcontrollers()
    }

    /// Set up the tabBar appearance with standard darkmode compatible colors.
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }

    /// Set up each viewControllers in the TabBar
    /// For continuity of iOS look and feel, SFSymbols are used as icon images
    private func setupViewcontrollers() {
        let rateIconImage = UIImage(systemName: "arrow.triangle.2.circlepath")!
        let rateViewController = createController(for: RateViewController(),
                                                  title: "Exchange rates",
                                                  image: rateIconImage)

        let translateIconImage = UIImage(systemName: "globe")!
        let translationViewController = createController(for: TranslationViewController(),
                                                         title: "Translation",
                                                         image: translateIconImage)
        let weatherIconImage = UIImage(systemName: "cloud.sun.fill")!
        let weatherViewController = createController(for: WeatherViewController(),
                                                     title: "Weather",
                                                     image: weatherIconImage)
        viewControllers = [rateViewController,
                           translationViewController,
                           weatherViewController
        ]
    }

    /// Create a navigation controller  for each tab with an icon inmage and a title.
    /// Large title have been set as default to keep the iOS look and feel.
    /// - Parameters:
    ///   - rootViewController: Name of the ViewController assiciated to the tab
    ///   - title: Title name of the tab
    ///   - image: Name of the image
    /// - Returns: A modified ViewController
    private func createController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }


}
