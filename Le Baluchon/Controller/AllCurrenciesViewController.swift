//
//  AllCurrenciesViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import UIKit

class AllCurrenciesViewController: UIViewController {

    private let tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .insetGrouped)
        tbv.backgroundColor = .clear
        tbv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()

    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        lbl.textColor = .label
        lbl.text = "Devises disponibles"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    weak var exchangeDelegate: ExchangeDelegate?
    private var currencyList: [Currencies] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        setDelegates()
        setupTitleLabelConstraints()
        setupTableViewConstraints()
        getCurrencies()
    }

    // MARK: - Setup
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTitleLabelConstraints() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }

    // MARK: - Datas
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
                print(error.localizedDescription)
            }
        }
    }

    private func createCurrenciesList(with currencyDictionnary: [String: String]) {
        for (keys, values) in currencyDictionnary {
            let post = Currencies(symbol: keys, name: values)
            self.currencyList.append(post)
        }
    }
}

// MARK: - Extensions
extension AllCurrenciesViewController: UITableViewDataSource {

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

extension AllCurrenciesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencyList[indexPath.row]
        // pass the selected row currency 3 letters symbol to the RateViewController
        // thru a protocol and dismiss the current modal ViewController.
        exchangeDelegate?.updateCurrency(with: currency.symbol)
        dismiss(animated: true, completion: nil)
    }
}

