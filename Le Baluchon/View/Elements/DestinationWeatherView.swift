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
        setConditionsStackView()
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
        uiv.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.6).isActive = true
        return uiv
    }()

    let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "--"
        lbl.font = .textFontSemiBold(size: 23)
        lbl.sizeToFit()
        lbl.textColor = .titleColor
        lbl.numberOfLines = 3
        lbl.textAlignment = .left
        return lbl
    }()

    let searchButton: UIButton = {
        let btn = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig)
        btn.setImage(image, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return btn
    }()

    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()

    let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "?°"
        lbl.font = .temperatureFont(size: 90)
        lbl.textColor = .titleColor.withAlphaComponent(0.8)
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return lbl
    }()

    let conditionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Conditions indisponibles"
        lbl.font = .textFontSemiBold(size: 25)
        lbl.textColor = .titleColor.withAlphaComponent(0.8)
        lbl.sizeToFit()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        return lbl
    }()

    let conditionsIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.contentMode = .scaleAspectFit
        uiv.addShadow(verticalOffset: 5, radius: 5)
        uiv.translatesAutoresizingMaskIntoConstraints = false
        uiv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        uiv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return uiv
    }()

    private let conditionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

// MARK: - Constraints
extension DestinationWeatherView {

    private func setConditionsStackView() {
        conditionsStackView.addArrangedSubview(conditionsIcon)
        conditionsStackView.addArrangedSubview(conditionsLabel)
    }

    private func setStackViewConstraints() {
        titleStackView.addArrangedSubview(cityLabel)
        titleStackView.addArrangedSubview(searchButton)

        addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [titleStackView,
                                           weatherIcon,
                                           temperatureLabel,
                                           conditionsStackView]
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        mainStackView.setCustomSpacing(-10, after: weatherIcon)
        mainStackView.setCustomSpacing(-20, after: temperatureLabel)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
