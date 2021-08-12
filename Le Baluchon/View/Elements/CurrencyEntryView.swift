//
//  CurrencyEntryView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

class CurrencyEntryView: UIView {

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
    let textfield: UITextField = {
        let txf = UITextField()
        txf.keyboardType = .decimalPad
        txf.font = .textFont(size: 40)
        txf.adjustsFontSizeToFitWidth = true
        txf.contentMode = .left
        txf.textColor = .titleColor
        txf.tintColor = .titleColor
        txf.placeholder = "0"
        txf.translatesAutoresizingMaskIntoConstraints = false
        txf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return txf
    }()

    let currencyButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.subtitleColor, for: .normal)
        btn.titleLabel?.font = .textFont(size: 21)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return btn
    }()

    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFont(size: 12)
        lbl.textColor = .subtitleColor
        lbl.sizeToFit()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()

    private let currencyStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .top
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Constraints
extension CurrencyEntryView {

    private func setStackViewConstraints() {
        currencyStackView.addArrangedSubview(currencyButton)
        currencyStackView.addArrangedSubview(nameLabel)

        stackView.addArrangedSubview(textfield)
        stackView.addArrangedSubview(currencyStackView)

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
