//
//  WeatherDetailInfoView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation
import UIKit

class WeatherDetailInfoView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(iconName: String, title: String) {
        self.init()
        self.typeIcon.image = UIImage(named: iconName)
        self.titleLabel.text = title
    }

    // MARK: - Subviews
    private let typeIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.tintColor = .label
        uiv.contentMode = .scaleAspectFit
        uiv.translatesAutoresizingMaskIntoConstraints = false
        uiv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return uiv
    }()

    let valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "--"
        lbl.font = .textFontSemiBold(size: 19)
        lbl.textColor = .titleColor
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 21).isActive = true
        return lbl
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .textFont(size: 12)
        lbl.textColor = .subtitleColor
        lbl.sizeToFit()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
    // MARK: - Constraints
extension WeatherDetailInfoView {

    private func setStackViewConstraints() {
        addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [typeIcon,
                                           valueLabel,
                                           titleLabel
        ]
        for view in mainStackSubViews {
            mainStackView.addArrangedSubview(view)
        }
        NSLayoutConstraint.activate([
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
