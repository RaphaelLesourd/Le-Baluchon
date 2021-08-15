//
//  ViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class ExchangeViewController: UIViewController {

    // MARK: - Properties
    private let exchangeView = ExchangeMainView()
    private let rateCalculator = RateCalculator()
    private let rateService = RateService()
    private var currencyButtonTag: Int?
    private var currentRate: Double = 1.0 {
        didSet {
            updateDailyRate(with: currentRate)
            getConvertedAmount()
            updateLastFetchDate()
        }
    }
    private var originCurrency: Currency? {
        didSet {
            exchangeView.originCurrencyView.currencyButton.setTitle(originCurrency?.symbol,
                                                                    for: .normal)
            exchangeView.originCurrencyView.nameLabel.text = originCurrency?.name
        }
    }
    private var targetCurrency: Currency? {
        didSet {
            exchangeView.targetCurrencyView.currencyButton.setTitle(targetCurrency?.symbol,
                                                                       for: .normal)
            exchangeView.targetCurrencyView.nameLabel.text = targetCurrency?.name
        }
    }
    private var originAmount: String? {
        didSet {
            guard let originAmount = originAmount else {return}
            rateCalculator.amountToConvert = originAmount
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
        targetCurrency = Currency(symbol: "USD", name: "Dollars")
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
            .targetCurrencyView
            .currencyButton
            .addTarget(self,action: #selector(displayCurrenciesList(_:)),
                       for: .touchUpInside)
        exchangeView
            .currencySwapButton
            .addTarget(self,action: #selector(currencySwapButtonTapped),
                       for: .touchUpInside)
    }

    // MARK: - API Call
    //  - Request exhange rate for currencies.
    @objc private func getRate() {
        guard let originCurrency = originCurrency else {return}
        guard let targetCurrency = targetCurrency else {return}
        toggleActiviyIndicator(for: exchangeView.headerView.activityIndicator, shown: true)

        rateService.getRate(for: originCurrency.symbol,
                            destinationCurrency: targetCurrency.symbol) { [weak self] result in
            guard let self = self else {return}
            self.stopRefreshActivitycontrol()
            switch result {
            case .success(let rate):
                guard let rateValue = rate.rates.values.first else {return}
                self.currentRate = rateValue
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }

    private func stopRefreshActivitycontrol() {
        self.toggleActiviyIndicator(for: self.exchangeView.headerView.activityIndicator,
                                    shown: false)
        self.exchangeView.refresherControl.perform(#selector(UIRefreshControl.endRefreshing),
                                                   with: nil,
                                                   afterDelay: 0.1)
    }

    // MARK: - Conversion
    private func getConvertedAmount() {
        rateCalculator.convertAmount(with: currentRate) { result in
            switch result {
            case .success(let amount):
                exchangeView.targetCurrencyView.textfield.text = amount.formatted()
            case .failure(let error):
                presentErrorAlert(with: error.description)
            }
        }
    }

    // MARK: - Currencies swap
    /// Swap currency function and update echange rate value.
    @objc private func currencySwapButtonTapped() {
        swapCurrencies()
        rateCalculator.invertRates(for: currentRate) { result in
            switch result {
            case .success(let newRate):
                currentRate = newRate
                animateCurrencySwapButton()
            case .failure(let error):
                presentErrorAlert(with: error.description)
            }
        }
    }
    /// Swaps origin and destination currency object.
    private func swapCurrencies() {
        // local cotanstant to store origin currency
        let tempCurrency = originCurrency
        self.originCurrency = targetCurrency
        self.targetCurrency = tempCurrency
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
        guard let destinationCurrency = targetCurrency else {return}
        exchangeView.dailyRateView.rateLabel.text = "1 \(originCurrency.symbol) = \(rate.formatted()) \(destinationCurrency.symbol)"
    }
    private func updateLastFetchDate() {
        let date = Date()
        exchangeView.dailyRateView.lastUpdateLabel.text = "Mis à jour le " + date.toString()
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



// MARK: - CurrencyList Delegate
extension ExchangeViewController: CurrencyListDelegate {
    /// Set origin or destination currency.
    /// - The tapped button is tracked by the currencyButtonTag property.
    /// - When one of the currency is change, new echange rate is fetched.
    /// - Parameter symbol: Currency object returned from ExchangeDelegate protocol.
    func updateCurrency(with currency: Currency) {
        if currencyButtonTag == 0 {
            originCurrency = currency
        } else {
            targetCurrency = currency
        }
        getRate()
    }
}
// MARK: - TextField Delegate
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

