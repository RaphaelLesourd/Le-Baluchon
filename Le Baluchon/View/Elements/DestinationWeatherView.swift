//
//  DestinationWeatherView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation
import UIKit

class DestinationWeatherView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views
    let weatherIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.image = #imageLiteral(resourceName: "thunder_sunny_color")
        uiv.contentMode = .scaleAspectFit
        uiv.addShadow()
        uiv.translatesAutoresizingMaskIntoConstraints = false
        uiv.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
        return uiv
    }()

    let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "New York, Etats-Unis"
        lbl.font = .textFontSemiBold(size: 24)
        lbl.sizeToFit()
        lbl.textColor = .titleColor
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        return lbl
    }()

    let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "35°"
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
        lbl.text = "Orages violents"
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
        mainStackView.setCustomSpacing(-10, after: temperatureLabel)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
