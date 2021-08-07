//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class TranslationViewController: UIViewController {

    // MARK: - Properties
   
    // MARK: - Lifecycle

    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        let translationView = TranslationMainView()
        view = translationView
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerColor
        addKeyboardDismissGesture()
    }
    

}
