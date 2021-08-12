//
//  Refresher.swift
//  Le Baluchon
//
//  Created by Birkyboy on 12/08/2021.
//

import Foundation
import UIKit

class Refresher: UIRefreshControl {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.tintColor = .label
        self.attributedTitle = NSAttributedString(string: "Mise à jour")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
