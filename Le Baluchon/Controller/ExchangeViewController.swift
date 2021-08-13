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
            updateDailyRate(with: currentRate)
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
        addKeyboardDismissGesture()
        setDelegates()
        setButtonsTarget()
        setRefresherControl()
        setDefaultValues()
        getRate()
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
        originAmount = currentRate.formatted()
        exchangeView.originCurrencyView.textfield.text = originAmount
    }

    /// Adds a refreshed to the scrollView, trigger a neworl call to fetch latest exchange rate.
    private func setRefresherControl() {
        exchangeView.scrollView.refreshControl = exchangeView.refresherControl
        exchangeView.refresherControl.addTarget(self, action: #selector(getRate), for: .valueChanged)
    }

    /// Add targets to UIButtons.
    private func setButtonsTarget() {
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
            self.exchangeView.refresherControl.perform(#selector(UIRefreshControl.endRefreshing),
                                                       with: nil,
                                                       afterDelay: 0.1)
            switch result {
            case .success(let rate):
                guard let rateValue = rate.rates.values.first else {return}
                self.currentRate = rateValue
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }

    // MARK: - Calculate
    private func getConvertedAmount() {
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
        animateCurrencySwapButton()
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
    /// - Devides 1 by the currentValue rather to give the opposite value.
    /// - It avoids making another network call to get the new exchange rate.
    private func updateRateValue() {
        currentRate = 1 / currentRate
    }

    /// Rotate the currencySwaButton with animation.
    /// - Rotate the button 180°
    /// - Set the button to its orginial state once the animation is complete.
    private func animateCurrencySwapButton() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
            self.exchangeView
                .currencySwapButton
                .transform = CGAffineTransform.identity.rotated(by: .pi)
        } completion: { _ in
            self.exchangeView.currencySwapButton.transform = .identity
        }
    }

    // MARK: - Daily Rate
    private func updateDailyRate(with rate: Double) {
        guard let originCurrency = originCurrency else {return}
        guard let destinationCurrency = destinationCurrency else {return}
        exchangeView.dailyRateView.rateLabel.text = "1 \(originCurrency.symbol) = \(rate.formatted()) \(destinationCurrency.symbol)"
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
            originAmount = updatedText
            getConvertedAmount()
        }
        return true
    }
}

