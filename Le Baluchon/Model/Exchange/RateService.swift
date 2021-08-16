//
//  RateService.swift
//  Le Baluchon
//
//  Created by Birkyboy on 11/08/2021.
//

import Foundation

class RateService {

    func getRate(for baseCurrency: String, destinationCurrency: String,
                     completion: @escaping (Result<Rate, ApiError>) -> Void) {
        guard let request = createRequest(with: baseCurrency, and: destinationCurrency) else {
            return
        }
        ApiService.shared.getData(for: Rate.self, request: request) { result in
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

        let endPoint = "latest?base=\(baseCurrency)&symbols=\(destinationCurrency)&access_key="
        guard let rateURL = URL(string: ApiURL.ifixerURL + endPoint +  ApiKeys.ifixerKEY ) else {
            return nil
        }
        var request = URLRequest(url: rateURL)
        request.httpMethod = "GET"
        return request
    }
}

