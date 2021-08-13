//
//  DestinationWeatherView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation
import UIKit

class DestinationWeatherView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews
    let weatherIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.contentMode = .scaleAspectFit
        uiv.addShadow()
        uiv.translatesAutoresizingMaskIntoConstraints = false
        uiv.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        return uiv
    }()

    let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFontSemiBold(size: 26)
        lbl.sizeToFit()
        lbl.textColor = .titleColor
        lbl.numberOfLines = 3
        lbl.textAlignment = .left
        return lbl
    }()

    let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .temperatureFont(size: 100)
        lbl.textColor = .subtitleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return lbl
    }()

    let conditionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFont(size: 21)
        lbl.textColor = .subtitleColor
        lbl.sizeToFit()
        lbl.numberOfLines = 2
        lbl.textAlignment = .right
        return lbl
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

// MARK: - Constraints
extension DestinationWeatherView {
    private func setStackViewConstraints() {
        addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [cityLabel,
                                           weatherIcon,
                                           temperatureLabel,
                                           conditionsLabel
        ]
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        mainStackView.setCustomSpacing(10, after: cityLabel)
        mainStackView.setCustomSpacing(-30, after: weatherIcon)
        mainStackView.setCustomSpacing(-20, after: temperatureLabel)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
