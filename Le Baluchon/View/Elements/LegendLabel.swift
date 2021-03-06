//
//  FooterLabel.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

/// Create a reusable custom label to display data providers in all tabs
class LegendLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.font = .textFont(size: 15)
        self.textColor = .titleColor
        self.numberOfLines = 2
        self.sizeToFit()
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    convenience init(title: String) {
        self.init()
        self.text = title + "\nTirez pour rafraichir"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
