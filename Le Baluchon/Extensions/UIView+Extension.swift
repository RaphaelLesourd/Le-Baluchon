//
//  UIView_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation
import UIKit

extension UIView {

    /// Helper function to round corners of a view.
    /// - A default view in the app is rounded with no background color (clear) and has a blur effect.
    /// - Parameters:
    ///   - radius: Corner radius value, 17 by default.
    ///   - backgroundcolor: Color of the background, clear by default.
    ///   - withBlur: Boolean value if a blur effect should be added, true by default.
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
    /// Adds a blur effet to a view.
    func addBlurEffect(blurStyle: UIBlurEffect.Style = .prominent,
                       transparency: CGFloat = 0.7) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = transparency
        blurredEffectView.frame = self.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurredEffectView)
    }
    /// Add a shadow to a view.
    /// - Parameters:
    ///   - opacity: Opacity of the shadow, by default 0.3
    ///   - verticalOffset: height the shadiw, 10 by default
    ///   - radius: Shadow spread, by default 20
    ///   - color: Shadow color, black by default
    func addShadow(opacity: Float = 0.3,
                   verticalOffset: CGFloat = 10,
                   radius: CGFloat = 20,
                   color: UIColor = .black) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: verticalOffset)
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
