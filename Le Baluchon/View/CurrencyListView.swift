//
//  CurrencyListView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation
import UIKit

protocol CurrencyListDelegate: AnyObject {
    func updateCurrency(with currency: Currency)
}

class CurrencyListView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTitleLabelConstraints()
        setSearchBarConstraints()
        setTableViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subviews
    let tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .insetGrouped)
        tbv.backgroundColor = .clear
        tbv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()

    let refresherControl = Refresher(frame: .zero)

    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFont(size: 21)
        lbl.textColor = .label
        lbl.text = "Devises disponibles"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        bar.backgroundColor = UIColor.viewControllerBackgroundColor
        bar.searchTextField.tintColor = .label
        bar.autocapitalizationType = .words
        bar.autocorrectionType = .no
        bar.enablesReturnKeyAutomatically = true
        bar.returnKeyType = .done
        bar.placeholder = "Recherche"
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    // MARK: - Setup
    private func setTitleLabelConstraints() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }

    private func setSearchBarConstraints() {
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setTableViewConstraints() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
