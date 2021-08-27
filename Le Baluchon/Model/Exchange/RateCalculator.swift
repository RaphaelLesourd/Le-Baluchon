//
//  ConvertRate.swift
//  Le Baluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class RateCalculator {

    var amountToConvert: String?
    var currentRate: Double?

    /// Convert an amout to using the current rate
    /// - Parameter completion: Return ta result with either a Double or an error.
    func convertAmount(completion: (Result<Double, ConversionError>) -> Void) {
        // Unwrap currentRate optional
        guard let currentRate = currentRate else {
            completion(.failure(.noData))
            return
        }
        // Check if the amountToConvert string contains anything, if not return 0 has default.
        if amountToConvert?.count == 0 {
            amountToConvert = "0"
        }
        // replace the comma sign with a period sign in orer to convert the string to Double.
        guard let amount = amountToConvert?.replaceDecimal() else {
            completion(.failure(.calculation))
            return
        }
        // Check if a second decimal symbol is entered, if there is remove it and inform the user.
        guard !amount.singleDecimalSymbol else {
            self.amountToConvert = String(amount.dropLast())
            completion(.failure(.format))
            return
        }
        // Convert the amount to a Double
        guard let doubleCurrency = Double(amount) else {
            completion(.failure(.calculation))
            return
        }
        // If all checks passes pass back the converted amount.
        completion(.success(doubleCurrency * currentRate))
    }

    /// Invert rate value. for example EUR/USD to USD/EUR by dividing 1 by the currentRate.
    func invertRates() {
        guard let currentRate = self.currentRate, currentRate != 0 else {
            return
        }
        self.currentRate =  1 / currentRate
    }
}
