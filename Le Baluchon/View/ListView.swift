//
//  CurrencyListView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation
import UIKit

class ListView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTitleLabelConstraints()
        setSearchBarConstraints()
        setTableViewConstraints()
    }

    convenience init(title: String) {
        self.init()
        self.headerView.titleLabel.text = title
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

    let headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return view
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
}

    // MARK: - Constraints
extension ListView {

    private func setTitleLabelConstraints() {
        addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func setSearchBarConstraints() {
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
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
