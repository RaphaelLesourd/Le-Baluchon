//
//  FooterLabel.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

/// Create a reusable custom label to display data providers in all tabs
class FooterLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.textColor = .titleColor
        self.numberOfLines = 2
        self.sizeToFit()
        self.textAlignment = .center
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
