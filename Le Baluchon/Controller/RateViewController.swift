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
        view.backgroundColor = .viewControllerColor
        setDelegates()
        addKeyboardDismissGesture()
        buttonTagets()
    }

    // MARK: - Setup
    private func setDelegates() {
        rateView.originCurrencyView.textfield.delegate = self
    }

    private func buttonTagets() {
        rateView.originCurrencyView.currencyButton.addTarget(self,
                                                             action: #selector(displayCurrenciesList),
                                                             for: .touchUpInside)
        rateView.destinationCurrencyView.currencyButton.addTarget(self,
                                                             action: #selector(displayCurrenciesList),
                                                             for: .touchUpInside)
    }

    // MARK: - Navigation
    @objc private func displayCurrenciesList() {
        let currenciesList = AllCurrenciesViewController()
        present(currenciesList, animated: true, completion: nil)
    }
}

extension RateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

