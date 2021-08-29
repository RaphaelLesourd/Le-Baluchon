//
//  SunTimesView.swift
//  LeBaluchon
//
//  Created by Birkyboy on 19/08/2021.
//

import Foundation
import UIKit

class SunTimesView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.rounded()
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let sunRiseView = SunTimingView(systemIconName: "sunrise")
    let sunSetView = SunTimingView(systemIconName: "sunset")

    let sunProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressViewStyle = .default
        progress.trackTintColor = .tertiaryLabel
        progress.progressImage = #imageLiteral(resourceName: "gradient")
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.heightAnchor.constraint(equalToConstant: 6).isActive = true
        return progress
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        sunProgressView.trackTintColor = .tertiaryLabel
    }
}
// MARK: - Constraints
extension SunTimesView {

    private func setStackViewConstraints() {
        stackView.addArrangedSubview(sunRiseView)
        stackView.addArrangedSubview(sunProgressView)
        stackView.addArrangedSubview(sunSetView)

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ])
    }
}
