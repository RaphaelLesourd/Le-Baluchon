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
            rateView.convertedCurrencyView.currencyButton.setTitle(destinationCurrencySymbol,
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
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultValues()
        setDelegates()
        addKeyboardDismissGesture()
        buttonTargets()
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
    }

    private func buttonTargets() {
        rateView
            .originCurrencyView
            .currencyButton
            .addTarget(self,action: #selector(displayCurrenciesList(_:)),
                       for: .touchUpInside)
        rateView
            .convertedCurrencyView
            .currencyButton
            .addTarget(self,action: #selector(displayCurrenciesList(_:)),
                       for: .touchUpInside)
        rateView.currencySwapButton.addTarget(self, action: #selector(currencySwapButtonTapped),
                                              for: .touchUpInside)
    }

    // MARK: - Data Request

    //  - Request exhange rate for currencies.
    //  - update converted currency view

    // MARK: - Currencies swap
    /// Call swap currency function.
    @objc private func currencySwapButtonTapped() {
        swapCurrencies(&originCurrencySymbol, &destinationCurrencySymbol)
    }

    /// Swap oigin and destination currency.
    /// - Use of tuple to reduce the amount of code, instead of having a temporary transit value to store the destination currency.
    /// - Parameters:
    ///   - origin: originCurrencySymbol property.
    ///   - destination: destinationcurrencySymbol protperty.
    private func swapCurrencies(_ origin: inout String, _ destination: inout String) {
        (origin, destination) = (destination, origin)
    }

    // MARK: - Navigation

    /// Present a modal viewController with a list of all currencies available.
    /// - Parameter sender: Tapped UIButton
    @objc private func displayCurrenciesList(_ sender: UIButton) {
        // set the UIbutton sender tag to the currencyButtonTag property to keep track which
        // button has been pushed.
        currencyButtonTag = sender.tag
        // Instanciate the viewController to call.
        let currenciesList = CurrencyListViewController()
        currenciesList.exchangeDelegate = self
        // Present the view controller modally.
        present(currenciesList, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension ExchangeViewController: ExchangeDelegate {

    /// Set origin or destination currency.
    /// - The tapped button is tracked by the currencyButtonTag property.
    /// - Parameter symbol: Currency 3 letters code symbol returned from ExchangeDelegate protocol.
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

