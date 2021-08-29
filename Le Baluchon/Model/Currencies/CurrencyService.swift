//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

class CurrencyService {

    var apiService = ApiService.shared

    func getCurrencies(completion: @escaping (Result<CurrencyList, ApiError>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/symbols"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: ApiKeys.ifixerKEY)
        ]
        apiService.getData(with: urlComponents.url) { (result: Result<CurrencyList, ApiError>) in
            completion(result)
        }
    }
}
