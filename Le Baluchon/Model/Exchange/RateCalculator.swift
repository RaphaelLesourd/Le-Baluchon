//
//  ConvertRate.swift
//  Le Baluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class RateCalculator {

    var amountToConvert: String?

    func convertAmount(with rate: Double,
                       completion: (Result<Double, ConversionError>) -> Void) {
        
        guard amountToConvert?.count != 0 else {
            completion(.failure(.noAmount))
            return
        }
        guard let currency = amountToConvert?.replaceDecimal() else {
            completion(.failure(.calculation))
            return
        }
        guard !currency.singleDecimalSymbol else {
            completion(.failure(.format))
            return
        }
        guard let doubleCurrency = Double(currency) else {
            completion(.failure(.calculation))
            return
        }
        completion(.success(doubleCurrency * rate))
    }

    func invertRates(for rate: Double,
                     completion: (Result<Double, ConversionError>) -> Void) {
        guard rate != 0 else {
            completion(.failure(.zeroDivision))
            return
        }
        let oppositeRate = 1 / rate
        completion(.success(oppositeRate))
    }
}
