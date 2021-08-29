//
//  Double_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

extension Double {

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

    func formatCurrency(currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.positivePrefix = "\(formatter.positivePrefix ?? "") "
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? "0"
    }
}
