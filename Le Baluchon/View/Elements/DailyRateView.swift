//
//  DailyRateView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 13/08/2021.
//

import Foundation
import UIKit

class DailyRateView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.rounded()
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    let rateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .titleColor
        lbl.font = .textFont(size: 21)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        return lbl
    }()

    let lastUpdateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mis à jour le "
        lbl.textColor = .subtitleColor
        lbl.font = .textFont(size: 12)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        return lbl
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Constraints
extension DailyRateView {

    private func setStackViewConstraints() {
        stackView.addArrangedSubview(rateLabel)
        stackView.addArrangedSubview(lastUpdateLabel)

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
