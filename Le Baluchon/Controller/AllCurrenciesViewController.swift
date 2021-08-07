//
//  AllCurrenciesViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import UIKit

class AllCurrenciesViewController: UIViewController {

    private var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)

    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        lbl.textColor = .label
        lbl.text = "Devises disponibles"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private var currenciesArray: [String] = []


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerColor
        setupTitleLabelConstraints()
        setupTableView()
    }

    // MARK: - Setup Views
    private func setupTitleLabelConstraints() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - Extensions
extension AllCurrenciesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}

extension AllCurrenciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 80 //currenciesArray.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let currency = currenciesArray[indexPath.row]
        cell.textLabel?.text = "EUR"
        cell.detailTextLabel?.text = "Euro"
        return cell
    }


}
