//
//  RateService.swift
//  Le Baluchon
//
//  Created by Birkyboy on 11/08/2021.
//

import Foundation

class RateService {

    var apiService = ApiService.shared

    func getRate(for baseCurrency: String, destinationCurrency: String,
                     completion: @escaping (Result<Rate, ApiError>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/api//latest"
        urlComponents.queryItems = [
            URLQueryItem(name: "base", value: baseCurrency),
            URLQueryItem(name: "symbols", value: destinationCurrency),
            URLQueryItem(name: "access_key", value: ApiKeys.ifixerKEY)
        ]

        apiService.getData(for: Rate.self, with: urlComponents.url) { result in
            switch result {
            case .success(let rate):
                completion(.success(rate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
