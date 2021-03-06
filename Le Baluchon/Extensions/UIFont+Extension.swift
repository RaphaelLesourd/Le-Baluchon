//
//  UIFont_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation
import UIKit

/// Custom fonts use in the app
extension UIFont {
    static func textFont(size: CGFloat) -> UIFont {
        return UIFont(name: "GalanoGrotesque-Medium", size: size) ??
            UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func textFontBold(size: CGFloat) -> UIFont {
        return UIFont(name: "GalanoGrotesque-Bold", size: size) ??
            UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func textFontSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "GalanoGrotesque-SemiBold", size: size) ??
            UIFont.systemFont(ofSize: size, weight: .semibold)
    }

    static func temperatureFont(size: CGFloat) -> UIFont {
        return UIFont(name: "ITCAvantGardeStd-Bold", size: size) ??
            UIFont.monospacedSystemFont(ofSize: size, weight: .bold)
    }
}
