//
//  Currencies.swift
//  Le Baluchon
//
//  Created by Birkyboy on 07/08/2021.
//

import Foundation

struct CurrencyList: Decodable {
    let symbols: [String: String]
}

struct Currencies {
    var symbol: String
    var name: String
}
