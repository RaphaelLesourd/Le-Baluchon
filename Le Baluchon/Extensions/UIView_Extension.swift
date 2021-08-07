//
//  UIView_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

extension UIView {

    func rounded(radius: CGFloat = 17,
                 backgroundcolor: UIColor = .clear,
                 withBlur: Bool = true) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.backgroundColor = backgroundcolor
        if withBlur {
            addBlurEffect()
        }
    }

    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 0.8
        blurredEffectView.frame = self.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurredEffectView)
    }
}
