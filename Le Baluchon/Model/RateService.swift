//
//  RateService.swift
//  Le Baluchon
//
//  Created by Birkyboy on 11/08/2021.
//

import Foundation


class RateService {

    // MARK: - Properties
    static let shared = RateService()
    private init() {}

    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    var amountToConvert: String?

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(base: String, destination: String) -> URLRequest {
        let endPoint = "&base=\(base)&symbols=\(destination)"
        let rateURL = URL(string: ApiURL.ifixerURL + "latest?access_key=" + ApiKeys.ifixerKEY + endPoint)!
        var request = URLRequest(url: rateURL)
        request.httpMethod = "GET"
        return request
    }

    /// Fetch data from API
    ///
    /// - Parameter completion: Returns a Result.
    /// - Succes case:  currency list dictionary.
    /// - Error case :  Error of type ApiError.
    func getRateData(for originCurrency: String,
                     destination: String,
                     completion: @escaping (Result<[String:Double], ApiError>) -> Void) {
        // set current request returned from the createRequest method.
        let request = createRequest(base: originCurrency, destination: destination)
        // cancel previous task
        task?.cancel()
        // set current tast with a session datatask for the current request
        // returns data, a responses status and and eventually an error
        task = session.dataTask(with: request) { (data, response, error) in
            // run the rest of the code in the main thread
            DispatchQueue.main.async {
                // Unwrap data optional
                guard let data = data else {
                    completion(.failure(.errorFetching))
                    return
                }
                // check if the response code is 200. if true move on or return
                // completion failure case.
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(.failure(.httpError))
                    return
                }
                // do/catch block for trying to decode data returned from session dataTask
                do {
                    let responseJSON = try JSONDecoder().decode(Rate.self, from: data)
                    // return decoded JSON
                    completion(.success(responseJSON.rates))
                } catch {
                    // return an error in case of failure decoding JSON
                    completion(.failure(.decodingData))
                }
            }
        }
        // start the task
        task?.resume()
    }

// MARK: - Calculation

    func convertAmount(with rate: Double,
                       completion: (Result<Double,ConversionError>) -> Void) {

        guard amountToConvert != "0" else {
            completion(.failure(.zeroDivision))
            return
        }
        guard let currency = amountToConvert?.replaceDecimal() else {
            completion(.failure(.calculation))
            return
        }
        guard let doubleCurrency = Double(currency) else {
            return
        }
        completion(.success(doubleCurrency * rate))
    }
}

