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

        let request = createRequest(with: baseCurrency, and: destinationCurrency)
        apiService.getData(for: Rate.self, with: request) { result in
            switch result {
            case .success(let rate):
                completion(.success(rate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(with baseCurrency: String,
                               and destinationCurrency: String) -> URLRequest? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/api//latest"
        urlComponents.queryItems = [
            URLQueryItem(name: "base", value: baseCurrency),
            URLQueryItem(name: "symbols", value: destinationCurrency),
            URLQueryItem(name: "access_key", value: ApiKeys.ifixerKEY)
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
