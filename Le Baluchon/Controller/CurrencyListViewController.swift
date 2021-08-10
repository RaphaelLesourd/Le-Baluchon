//
//  AllCurrenciesViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import UIKit

class CurrencyListViewController: UIViewController {

    /// Intialise ExchangeDelegate protocol.
    weak var exchangeDelegate: ExchangeDelegate?
    /// Create an instance of CurrencyListView
    private let listView = CurrencyListView()
    /// Initialise an empty array of type Currencies.
    /// - When set, the tableView is reloaded.
    private var currencyList: [Currencies] = [] {
        didSet {
            currencyList = currencyList.sorted { $0.symbol < $1.symbol }
            DispatchQueue.main.async {
                self.listView.tableView.reloadData()
            }
        }
    }

    // MARK: - Life Cycle
    override func loadView() {
        view = listView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        getCurrencies()
    }

    // MARK: - Setup
    private func setDelegates() {
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
    }

    // MARK: - Api Call
    /// Get all available currencies from API and receive a result  type.
    /// success case:  dictionnary of all currencies available.
    /// failure case : an error.
    private func getCurrencies() {
        MoneySymbolsService.shared.getData { [weak self] result in
            guard let self = self else {return}
            // switch between the result 2 cases
            switch result {
            // if successful iterate thru a currency dictionnary and add each items
            // to the currrencyList array.
            case .success(let currency):
               self.createCurrenciesList(with: currency.symbols)
                // if call failed an error is presented to the user.
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }

    /// Iterate through a currency dictionnary returned from a JSON
    /// and add data to currencyList array of type Currencies.
    /// - Dictionnary key: currency 3 letter code symbol
    /// - Dictionnary value: currency name
    /// - Parameter currencyDictionnary: Dictionnary of type [String : String]
    private func createCurrenciesList(with currencyDictionnary: [String: String]) {
        for (keys, values) in currencyDictionnary {
            let post = Currencies(symbol: keys, name: values)
            self.currencyList.append(post)
        }
    }
}

// MARK: - Extensions
extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return currencyList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell as a generic UITableViewCell of subtitle style
        // to present the data with a title and a subtitle without having to create
        // a custom UITableViewcCell.
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // Set the currency list data to the title and subtitle label.
        let currency = currencyList[indexPath.row]
        cell.textLabel?.text = currency.symbol
        cell.detailTextLabel?.text = currency.name
        return cell
    }
}

extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencyList[indexPath.row]
        // pass the selected row currency 3 letters symbol to the ExchangeViewController
        // thru a protocol and dismiss the current modal ViewController.
        exchangeDelegate?.updateCurrency(with: currency.symbol)
        dismiss(animated: true, completion: nil)
    }
}

