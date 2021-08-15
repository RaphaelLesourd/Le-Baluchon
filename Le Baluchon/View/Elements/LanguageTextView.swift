//
//  TranslatioNTextView.swift
//  Le Baluchon
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation
import UIKit

class LanguageTextView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.rounded()
        setupTextViewConstraints()
        setupClearButtonConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(isEditable: Bool) {
        self.init()
        textView.isEditable = isEditable
        clearButton.isHidden = !isEditable
        let rightInset: CGFloat = isEditable ? 35 : 0
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightInset)
    }

    // MARK: - Subviews
    let clearButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .tertiaryLabel
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .large)
        let buttonImage = UIImage(systemName: "multiply.circle.fill", withConfiguration: imageConfig)
        btn.setImage(buttonImage, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let textView: UITextView = {
        let txv = UITextView()
        txv.layer.masksToBounds = true
        txv.backgroundColor = .clear
        txv.autocorrectionType = .yes
        txv.font = .textFont(size: 25)
        txv.textColor = .titleColor
        txv.tintColor = .titleColor
        txv.showsVerticalScrollIndicator = false
        txv.showsHorizontalScrollIndicator = false
        txv.isSelectable = true
        txv.alwaysBounceVertical = true
        txv.textAlignment = .natural
        txv.translatesAutoresizingMaskIntoConstraints = false
        return txv
    }()
}
// MARK: - Constraints
extension LanguageTextView {

    private func setupTextViewConstraints() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    private func setupClearButtonConstraints() {
        addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            clearButton.heightAnchor.constraint(equalToConstant: 32),
            clearButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
}
