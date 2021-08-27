//
//  AllCurrenciesViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import UIKit

protocol CurrencyListDelegate: AnyObject {
    func updateCurrency(with currency: Currency)
}

class CurrencyListViewController: UIViewController {

    // MARK: - Properties
    weak var exchangeDelegate: CurrencyListDelegate?
    private var currenciesService = CurrencyService()
    private let listView = ListView(title: "Devises")

    /// Array containing the entire list of currencies
    var currencyList: [Currency] = [] {
        didSet{
            filteredCurrencyList = currencyList
        }
    }
    /// Array containing flitered list of currencies
    private var filteredCurrencyList: [Currency] = [] {
        didSet {
            filteredCurrencyList = filteredCurrencyList.sorted { $0.symbol < $1.symbol }
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
        addKeyboardDismissGesture()
        setDelegates()
        setTableViewRefresherControl()
        getCurrencies()
    }

    // MARK: - Setup
    private func setDelegates() {
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.searchBar.delegate = self
    }

    private func setTableViewRefresherControl() {
        listView.tableView.refreshControl = listView.refresherControl
        listView.refresherControl.addTarget(self,
                                            action: #selector(reloadCurrencyList),
                                            for: .valueChanged)
    }

    // MARK: - API Call
    /// Get all available currencies from API and receive a result  type.
    /// success case:  dictionnary of all currencies available.
    /// failure case : an error.
    private func getCurrencies() {
        displayRefresherActivityControls(true)

        currenciesService.getCurrencies { [weak self] result in
            guard let self = self else {return}
            self.displayRefresherActivityControls(false)
            switch result {
            case .success(let currency):
               self.createCurrenciesList(with: currency.symbols)
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }
    /// Iterate through a currency dictionnary returned from  Api Call
    /// and add data to currencyList array of type Currencies.
    /// - Dictionnary key: currency 3 letter code symbol
    /// - Dictionnary value: currency name
    /// - Parameter currencyDictionnary: Currency list Dictionnary
    private func createCurrenciesList(with currencyDictionnary: [String: String]) {
        for (keys, values) in currencyDictionnary {
            let post = Currency(symbol: keys, name: values)
            self.currencyList.append(post)
        }
    }
    /// Reload the entire currency list.
    @objc private func reloadCurrencyList() {
        currencyList.removeAll()
        listView.searchBar.text = nil
        listView.searchBar.resignFirstResponder()
        getCurrencies()
    }
    /// Show/start or hide/stop activity control
    /// - Parameter status: Bool to set if activity control should be displayed or not
    private func displayRefresherActivityControls(_ status: Bool) {
        self.toggleActiviyIndicator(for: self.listView.headerView.activityIndicator,
                                    and: self.listView.refresherControl,
                                    showing: status)
    }
}

// MARK: - TableView DataSource
extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredCurrencyList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let currency = filteredCurrencyList[indexPath.row]
        cell.textLabel?.text = currency.symbol
        cell.detailTextLabel?.text = currency.name
        return cell
    }
}

// MARK: - TableView Delegate
extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = filteredCurrencyList[indexPath.row]
        let chosenCurrency = Currency(symbol: currency.symbol, name: currency.name)
        exchangeDelegate?.updateCurrency(with: chosenCurrency)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SearchBar Delegate
extension CurrencyListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            filteredCurrencyList = currencyList.filter({$0.symbol.contains(searchText.uppercased()) ||
                                                        $0.name.contains(searchText)})
        } else {
            filteredCurrencyList = currencyList
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listView.searchBar.resignFirstResponder()
    }
}

