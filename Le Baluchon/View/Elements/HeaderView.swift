//
//  TitleLabel.swift
//  Le Baluchon
//
//  Created by Birkyboy on 13/08/2021.
//

import Foundation
import UIKit

class HeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
    }

    convenience init(title: String) {
        self.init()
        titleLabel.text = title
    }

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFontSemiBold(size: 28)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        lbl.textAlignment = .left
        return lbl
    }()

    let activityIndicator:  UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .secondaryLabel
        indicator.style = .medium
        return indicator
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Constraints
extension HeaderView {

    private func setStackViewConstraints() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(activityIndicator)
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
