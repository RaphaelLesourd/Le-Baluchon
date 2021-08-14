//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

class CurrenciesService {
    
    static let shared = CurrenciesService()
    private init() {}

    private static let currenciesUrl = URL(string: ApiURL.ifixerURL + "symbols?access_key=" + ApiKeys.ifixerKEY)!
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }

    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest() -> URLRequest {
        var request = URLRequest(url: CurrenciesService.currenciesUrl)
        request.httpMethod = "GET"
        return request
    }

    /// Fetch data from API
    ///
    /// - Parameter completion: Returns a Result.
    /// - Succes case:  currency list dictionary.
    /// - Error case :  Error of type ApiError.
    func getData(completion: @escaping (Result<CurrencyList, ApiError>) -> Void) {
        // set current request returned from the createRequest method.
        let request = createRequest()
        // cancel previous task
        task?.cancel()
        // set current tast with a session datatask for the current request
        // returns data, a responses status and and eventually an error
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestError(error)))
                    return
                }
                guard let data = data else {
                    completion(.failure(.dataError))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.responseError))
                    return
                }
                guard response.statusCode == 200 else {
                    completion(.failure(.httpError(response.statusCode)))
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(CurrencyList.self, from: data)
                    completion(.success(responseJSON))
                } catch {
                    completion(.failure(.decodingData))
                }
            }
        }
        // start the task
        task?.resume()
    }
}
