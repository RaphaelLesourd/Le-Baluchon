//
//  TitleLabel.swift
//  Le Baluchon
//
//  Created by Birkyboy on 13/08/2021.
//

import Foundation
import UIKit

class TitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.font = .textFontSemiBold(size: 30)
        self.textColor = .titleColor
        self.numberOfLines = 1
        self.sizeToFit()
        self.textAlignment = .left
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    convenience init(title: String) {
        self.init()
        self.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
