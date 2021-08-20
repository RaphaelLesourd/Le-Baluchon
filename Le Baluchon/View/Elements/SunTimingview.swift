//
//  SunTimingsview.swift
//  LeBaluchon
//
//  Created by Birkyboy on 19/08/2021.
//

import Foundation
import UIKit

class SunTimingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(icon: UIImage) {
        self.init()
        sunIcon.image = icon
    }

    let sunIcon: UIImageView = {
        let uiv = UIImageView()
        uiv.contentMode = .scaleAspectFit
        uiv.translatesAutoresizingMaskIntoConstraints = false
        uiv.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return uiv
    }()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "--"
        lbl.textColor = .label
        lbl.font = .textFontSemiBold(size: 17)
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        return lbl
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Constraints
extension SunTimingView {

    private func setStackViewConstraints() {
        stackView.addArrangedSubview(sunIcon)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

}
