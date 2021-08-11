//
//  Currencies.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation

struct CurrencyList: Decodable {
    var symbols: [String: String]
}

struct Currency {
    var symbol: String
    var name: String
}
