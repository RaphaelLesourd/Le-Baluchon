//
//  DestinationWeatherInfoView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation
import UIKit

class DestinationWeatherInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setContainerViewConstraints()
        setupStackViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ContrainerView
    private let containerView: UIView = {
        let view = UIView()
        view.rounded()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setContainerViewConstraints() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    // MARK: - Info detail views
    let directionView = WeatherDetailInfoView(iconName: "direction", title: "Direction")
    let windView = WeatherDetailInfoView(iconName: "wind", title: "Vent")
    let visiblityView = WeatherDetailInfoView(iconName: "visibility", title: "Visibilité")
    let cloudView = WeatherDetailInfoView(iconName: "cloud", title: "Nuages")
    let pressureView = WeatherDetailInfoView(iconName: "pressure", title: "Préssion")
    let humidityView = WeatherDetailInfoView(iconName: "humidity", title: "Humidité")

    // MARK: - StackViews
    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    // bottom stackView
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    // main stackView
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setupStackViews() {

        topStackView.addArrangedSubview(directionView)
        topStackView.addArrangedSubview(windView)
        topStackView.addArrangedSubview(visiblityView)

        bottomStackView.addArrangedSubview(cloudView)
        bottomStackView.addArrangedSubview(pressureView)
        bottomStackView.addArrangedSubview(humidityView)

        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(bottomStackView)

        containerView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                               constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                  constant: -20),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                   constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                    constant: -10),
        ])
    }
    
}
