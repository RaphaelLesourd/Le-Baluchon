//
//  Double_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

extension Double {

    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber) ?? "1"
    }
}
