//
//  LanguagesChoiceView.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation
import UIKit

class LanguageChoicesView: UIView {
    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subviews
    let originLanguageButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .textFontSemiBold(size: 23)
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.minimumScaleFactor = 0.5
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.titleColor, for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.tag = 0
        return btn
    }()

    let targetLanguageButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .textFontSemiBold(size: 23)
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.minimumScaleFactor = 0.5
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.titleColor, for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.tag = 1
        return btn
    }()

    let languageDirectionButton: UIButton = {
        let btn = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .black, scale: .large)
        let image = UIImage(systemName: "arrow.right.circle.fill", withConfiguration: imageConfig)
        btn.setImage(image, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .systemPink
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return stack
    }()
}
// MARK: - Constraints
extension LanguageChoicesView {
    
    private func setStackView() {
        addSubview(stackView)
        stackView.addArrangedSubview(originLanguageButton)
        stackView.addArrangedSubview(languageDirectionButton)
        stackView.addArrangedSubview(targetLanguageButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            languageDirectionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
    }
}
