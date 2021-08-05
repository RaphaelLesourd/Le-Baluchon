//
//  ViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class RateViewController: UIViewController {

    // MARK: - Properties
    private let rateView = RateMainView()
    
    // MARK: - Lifecycle
    
    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = rateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
    }
}

