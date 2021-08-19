//
//  Double_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

extension Double {
    /// Format result displayed to the user. If result is a is whole number then no digiti is displayed.
    /// - Parameter value: Pass in a double value to be converted.
    /// - Returns: Result value converted to a string.
    func toString(decimals: Int = 3) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number) ?? "0"
        return formattedValue
    }
}
