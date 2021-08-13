//
//  OriginWeatherView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation
import UIKit

class LocalWeatherView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupStackViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subviews
    private let homeIcon: UIImageView = {
        let uiv = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .small)
        uiv.image = UIImage(systemName: "house.fill", withConfiguration: imageConfig)
        uiv.tintColor = .titleColor
        return uiv
    }()

    let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFont(size: 18)
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
        lbl.font = .textFont(size: 16)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()

    let weatherIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.addShadow()
        uiv.contentMode = .scaleAspectFit
        uiv.translatesAutoresizingMaskIntoConstraints = false
        uiv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return uiv
    }()

    let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .temperatureFont(size: 33)
        lbl.textColor = .subtitleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 35).isActive = true
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

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .trailing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Constraints
extension LocalWeatherView {
    
    /// Setup the mainStackView which hold all the UI subviews.
    private func setupStackViews() {
        cityStackView.addArrangedSubview(homeIcon)
        cityStackView.addArrangedSubview(cityLabel)

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
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
