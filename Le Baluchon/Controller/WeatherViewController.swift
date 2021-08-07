//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Properties

    // MARK: - Lifecycle

    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        let weatherView = WeatherMainView()
        view = weatherView
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerColor
        addKeyboardDismissGesture()
    }
 
}
