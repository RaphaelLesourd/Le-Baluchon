//
//  BackgroundImage.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

class BackgroundImage: UIImageView {


    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.alpha = 0.7
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
    }


    convenience init(image: UIImage) {
        self.init(frame: .zero)
        self.image = image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
