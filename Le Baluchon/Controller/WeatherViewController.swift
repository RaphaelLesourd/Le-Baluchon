//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Properties
    let weatherView = WeatherMainView()
    // MARK: - Lifecycle

    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = weatherView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Update views

    // update local weather
    // update destination weather
    // update destination extended weather

}
