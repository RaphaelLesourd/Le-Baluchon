//
//  ViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

protocol ExchangeDelegate: AnyObject {
    func updateCurrency(with symbol: String)
}

class ExchangeViewController: UIViewController {

    // MARK: - Properties
    private let rateView = ExchangeMainView()
    private var currencyButtonTag: Int?
    private var originCurrencySymbol = "" {
        didSet {
            rateView.originCurrencyView.currencyButton.setTitle(originCurrencySymbol,
                                                                for: .normal)
        }
    }
    private var destinationCurrencySymbol = "" {
        didSet {
            rateView.destinationCurrencyView.currencyButton.setTitle(destinationCurrencySymbol,
                                                                for: .normal)
        }
    }
    private var originCurrencyValue: Double? {
        didSet {
            guard let originCurrencyValue = originCurrencyValue else {return}
            rateView.originCurrencyView.textfield.text = originCurrencyValue.formatted()
        }
    }
    // MARK: - Lifecycle
    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = rateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        setDefaultValues()
        setDelegates()
        addKeyboardDismissGesture()
        buttonTagets()
    }

    // MARK: - Setup
    private func setDelegates() {
        rateView.originCurrencyView.textfield.delegate = self
    }

    /// Set up a default currency symbol, as per projet requirements, origin value is set with Euro symbol
    /// and destination symbol as US Dollars. The origin value is set to 1 to show the current exchange rate.
    private func setDefaultValues() {
        originCurrencySymbol = "EUR"
        destinationCurrencySymbol = "USD"
        originCurrencyValue = 1
        let value = "1234,56".replacingOccurrences(of: ",", with: ".")
        rateView.destinationCurrencyView.textfield.text = value
    }

    private func buttonTagets() {
        rateView
            .originCurrencyView
            .currencyButton
            .addTarget(self,action: #selector(displayCurrenciesList(_:)),
                       for: .touchUpInside)
        rateView
            .destinationCurrencyView
            .currencyButton
            .addTarget(self,action: #selector(displayCurrenciesList(_:)),
                       for: .touchUpInside)
        rateView.currencySwapButton.addTarget(self, action: #selector(currencySwapButtonTapped),
                                              for: .touchUpInside)
    }

    // MARK: - Currencies swap
    @objc private func currencySwapButtonTapped() {
        swapCurrencies(&originCurrencySymbol, &destinationCurrencySymbol)
        setDestinationCurrencyValueAsOrigin()
    }

    /// Swap oigin and destination values. Use of tuple to reduce the amount of code.
    /// Instead of having a temporary transit value
    /// - Parameters:
    ///   - origin: origin currency symbol
    ///   - destination: destination currency symbol
    private func swapCurrencies(_ origin: inout String, _ destination: inout String) {
        (origin, destination) = (destination, origin)
    }

    private func setDestinationCurrencyValueAsOrigin() {
        let destinationCurrencyValue = rateView.destinationCurrencyView.textfield.text
        guard let value = destinationCurrencyValue else {return}
        originCurrencyValue = Double(value)
    }

    // MARK: - Navigation

    /// Present a modal viewcontroller with a list of all currencies available.
    /// Sets the currencyButtonTag to track which button has been tapped.
    /// present the viewController.
    /// - Parameter sender: UIButton tapped calling the function
    @objc private func displayCurrenciesList(_ sender: UIButton) {
        currencyButtonTag = sender.tag
        let currenciesList = AllCurrenciesViewController()
        currenciesList.exchangeDelegate = self
        present(currenciesList, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension ExchangeViewController: ExchangeDelegate {

    /// Set the returned value from the exchangeDelegate protocol to the proper tapped button.
    /// The button is tracked by the currencyButtonTag property.
    /// - Parameter symbol: Currency 3 letters code symbol.
    func updateCurrency(with symbol: String) {
        if currencyButtonTag == 0 {
            originCurrencySymbol = symbol
        } else {
            destinationCurrencySymbol = symbol
        }
    }
}

extension ExchangeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

