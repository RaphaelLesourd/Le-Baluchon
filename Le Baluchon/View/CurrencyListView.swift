//
//  CurrencyListView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation
import UIKit

class CurrencyListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupTitleLabelConstraints()
        setupTableViewConstraints()
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

    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFont(size: 21)
        lbl.textColor = .label
        lbl.text = "Devises disponibles"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Setup
    private func setupTitleLabelConstraints() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    private func setupTableViewConstraints() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
