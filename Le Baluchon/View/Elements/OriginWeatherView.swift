//
//  OriginWeatherView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation
import UIKit

class OriginWeatherView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupStackViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: - City
    let homeIcon: UIImageView = {
        let uiv = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .small)
        uiv.image = UIImage(systemName: "house.fill", withConfiguration: imageConfig)
        uiv.tintColor = .titleColor
        return uiv
    }()

    let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "La Rochelle"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()

    private let cityStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    let countryLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "France"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()

    // MARK: - Weather detail
    let weatherIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.image = #imageLiteral(resourceName: "rain_heavy_color")
        uiv.addShadow()
        uiv.contentMode = .scaleAspectFit
        uiv.translatesAutoresizingMaskIntoConstraints = false
        return uiv
    }()

    let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "34°"
        lbl.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()

    private let weatherStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .trailing
        return stack
    }()

    // MARK: - Main StackView
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .trailing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    /// Setup the mainStackView which hold all the UI subviews.
    private func setupStackViews() {
        cityStackView.addArrangedSubview(homeIcon)
        cityStackView.addArrangedSubview(cityLabel)

        weatherIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherStackView.addArrangedSubview(weatherIcon)
        weatherStackView.addArrangedSubview(temperatureLabel)

        addSubview(mainStackView)
        // Create an array of the subviews to add to the stackView
        let mainStackSubViews: [UIView] = [cityStackView,
                                           countryLabel,
                                           weatherStackView
        ]
        // Iterate thru the subviews array to add them to the stak view
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        // Add constraints for the mainstackView
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
