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
    private let currenciesService = CurrencyService()
    /// Create an instance of CurrencyListView
    private let listView = ListView(title: "Devises")
    /// Initialise an empty array of type Currencies to use as a full list of currencies.
    /// - Stores the full list of currencies and copy  it to the filtered currency list array when set.
    private var currencyList: [Currency] = [] {
        didSet{
            filteredCurrencyList = currencyList
        }
    }
    /// Initialise an empty array of type Currencies to use to dsplay a full or filtererd list of currencies.
    private var filteredCurrencyList: [Currency] = [] {
        didSet {
            // Sort array alphabetically
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
        toggleActiviyIndicator(for: listView.headerView.activityIndicator, shown: true)
        currenciesService.getCurrencies { [weak self] result in
            guard let self = self else {return}
            self.toggleActiviyIndicator(for: self.listView.headerView.activityIndicator, shown: false)
            self.listView.refresherControl.perform(#selector(UIRefreshControl.endRefreshing),
                                                       with: nil,
                                                       afterDelay: 0.1)
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
}

// MARK: - TableView DataSource
extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredCurrencyList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set the cell as a generic UITableViewCell of subtitle style
        // to present the data with a title and a subtitle without having to create
        // a custom UITableViewcCell.
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // Set the currency list data to the title and subtitle label.
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
        // pass the selected row currency object to the ExchangeViewController
        // thru a protocol and dismiss the current modal ViewController.
        let chosenCurrency = Currency(symbol: currency.symbol, name: currency.name)
        exchangeDelegate?.updateCurrency(with: chosenCurrency)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SearchBar Delegate
extension CurrencyListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Oberve if the text did changed in the searchBar.
        // filters the currencyList array with search bar text either as currency symbol or
        // name.
        // If the searchBar text is empty, the list is reset with the full list from
        // the currencyList array
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

