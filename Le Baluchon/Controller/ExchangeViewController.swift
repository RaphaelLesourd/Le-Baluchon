//
//  ViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class ExchangeViewController: UIViewController {

    // MARK: - Properties
    private var currentRate: Double = 1.0 {
        didSet {
            print(currentRate)
            getConvertedAmount()
        }
    }
    private let exchangeView = ExchangeMainView()
    private var currencyButtonTag: Int?
    private var originCurrency: Currency? {
        didSet {
            exchangeView.originCurrencyView.currencyButton.setTitle(originCurrency?.symbol,
                                                                    for: .normal)
            exchangeView.originCurrencyView.nameLabel.text = originCurrency?.name
        }
    }
    private var destinationCurrency: Currency? {
        didSet {
            exchangeView.convertedCurrencyView.currencyButton.setTitle(destinationCurrency?.symbol,
                                                                       for: .normal)
            exchangeView.convertedCurrencyView.nameLabel.text = destinationCurrency?.name
        }
    }
    private var originAmount: String? {
        didSet {
            guard let originAmount = originAmount else {return}
            RateService.shared.amountToConvert = originAmount

        }
    }
    // MARK: - Lifecycle
    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = exchangeView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        addNavigationBarItem()
        addKeyboardDismissGesture()
        buttonTargets()
        setDefaultValues()
    }

    // MARK: - Setup
    private func setDelegates() {
        exchangeView.originCurrencyView.textfield.delegate = self
    }

    /// Set up a default currency symbol, as per projet requirements, origin value is set with Euro symbol
    /// and destination symbol as US Dollars. The origin value is set to 1 to show the current exchange rate.
    private func setDefaultValues() {
        originCurrency = Currency(symbol: "EUR", name: "Euro")
        destinationCurrency = Currency(symbol: "USD", name: "Dollars")
        originAmount = "1"
        exchangeView.originCurrencyView.textfield.text = originAmount
        getRate()
    }

    private func addNavigationBarItem() {
        let refreshImage = UIImage(systemName: "arrow.clockwise")
        let refreshButton = UIBarButtonItem(image: refreshImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(getRate))
        navigationItem.rightBarButtonItem = refreshButton
    }

    private func buttonTargets() {
        exchangeView
            .originCurrencyView
            .currencyButton
            .addTarget(self,action: #selector(displayCurrenciesList(_:)),
                       for: .touchUpInside)
        exchangeView
            .convertedCurrencyView
            .currencyButton
            .addTarget(self,action: #selector(displayCurrenciesList(_:)),
                       for: .touchUpInside)
        exchangeView
            .currencySwapButton
            .addTarget(self,action: #selector(currencySwapButtonTapped),
                       for: .touchUpInside)
    }

    // MARK: - Data Request
    //  - Request exhange rate for currencies.
    @objc private func getRate() {
        guard let originCurrency = originCurrency else {return}
        guard let destinationCurrency = destinationCurrency else {return}
        RateService.shared.getRateData(for: originCurrency.symbol,
                                       destination: destinationCurrency.symbol) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let rate):
                guard let rateValue = rate.values.first else {return}
                self.currentRate = rateValue
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }

    // MARK: - Calculate
    private func getConvertedAmount() {
     //   guard let currentRate = currentRate else {return}
        RateService.shared.convertAmount(with: currentRate) { result in
            switch result {
            case .success(let amount):
                exchangeView.convertedCurrencyView.textfield.text = amount.formatted()
            case .failure(let error):
                presentErrorAlert(with: error.description)
            }
        }
    }

    // MARK: - Currencies swap
    /// Swap currency function and update echange rate value.
    @objc private func currencySwapButtonTapped() {
        swapCurrencies()
        updateRateValue()
    }

    /// Swaps origin and destination currency object.
    private func swapCurrencies() {
        guard let originCurrency = originCurrency else {return}
        guard let destinationCurrency = destinationCurrency else {return}
        // local cotanstant to store origin currency
        let tempCurrency = originCurrency
        self.originCurrency = destinationCurrency
        self.destinationCurrency = tempCurrency
    }

    /// Update the exchange rate value after a swap.
    /// devides 1 by the currentValue rather than making another network call to get the new exchange rate.
    private func updateRateValue() {
        currentRate = 1 / currentRate
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

extension ExchangeViewController: CurrencyListDelegate {

    /// Set origin or destination currency.
    /// - The tapped button is tracked by the currencyButtonTag property.
    /// - When one of the currency is change, new echange rate is fetched.
    /// - Parameter symbol: Currency object returned from ExchangeDelegate protocol.
    func updateCurrency(with currency: Currency) {
        if currencyButtonTag == 0 {
            originCurrency = currency
        } else {
            destinationCurrency = currency
        }
        getRate()
    }
}

extension ExchangeViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print(updatedText)
            originAmount = updatedText
            getConvertedAmount()
        }
        return true
    }
}

