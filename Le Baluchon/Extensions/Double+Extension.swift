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
    func formatWithDecimals(decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? "0"
    }

    func formatWithUnit(in unitType: Unit) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .medium

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.locale = Locale(identifier: Locale.current.identifier)

        formatter.numberFormatter = numberFormatter
        let distanceMeasurement = Measurement(value: self, unit: unitType)
        return formatter.string(from: distanceMeasurement)
    }
}
