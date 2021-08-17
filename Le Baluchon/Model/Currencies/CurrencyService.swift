//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

class CurrencyService {

    func getCurrencies(completion: @escaping (Result<CurrencyList, ApiError>) -> Void) {

        guard let request = createRequest() else {
            completion(.failure(.urlError))
            return
        }
        ApiService.shared.getData(for: CurrencyList.self, request: request) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createRequest() -> URLRequest? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/symbols"
        urlComponents.queryItems = [
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
