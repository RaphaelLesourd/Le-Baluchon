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
        setupWeatherIcon()
        setCityLabelConstraints()
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Weather  Icon
    let weatherIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.image = #imageLiteral(resourceName: "thunder_sunny_color")
        uiv.contentMode = .scaleAspectFit
        uiv.addShadow()
        uiv.translatesAutoresizingMaskIntoConstraints = false
        return uiv
    }()

    private func setupWeatherIcon() {
        addSubview(weatherIcon)
        NSLayoutConstraint.activate([
            weatherIcon.topAnchor.constraint(equalTo: topAnchor),
            weatherIcon.bottomAnchor.constraint(equalTo: bottomAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -70),
            weatherIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70)
        ])
    }

    // MARK: - City Info
    let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "New York, Etats-Unis"
        lbl.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private func setCityLabelConstraints() {
        addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

    // MARK: - Weather infos

    let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "35°"
        lbl.font = UIFont.systemFont(ofSize: 70, weight: .black)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()

    let conditionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Orages violents"
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = .subtitleColor
        lbl.numberOfLines = 2
        lbl.textAlignment = .right
        return lbl
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setStackViewConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(conditionsLabel)
        stackView.setCustomSpacing(0, after: temperatureLabel)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
