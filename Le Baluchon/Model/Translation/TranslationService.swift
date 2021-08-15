//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class TranslationService {

    // MARK: - Properties
    static let shared = TranslationService()
    private init() {}

    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(with text: String, from orgin: String, to target: String) -> URLRequest? {

        let query = "?q=\(text.formattedForHttpRequest)&format=text&source=\(orgin)&target=\(target)&key="
        let url = ApiURL.googleTranslateURL + query + ApiKeys.googleTranslateKey
        print(url)
        guard let rateURL = URL(string: url) else {
            return nil
        }
        var request = URLRequest (url: rateURL)
        request.httpMethod = "GET"
        return request
    }
    /// Fetch data from API
    ///
    /// - Parameter completion: Returns a Result.
    /// - Succes case:  currency list dictionary.
    /// - Error case :  Error of type ApiError.
    func getTranslation(for text: String,
                        from orgin: String,
                        to target: String,
                        completion: @escaping (Result<Translation, ApiError>) -> Void) {
        // set current request returned from the createRequest method.
        guard let request = createRequest(with: text, from: orgin, to: target) else {
            completion(.failure(.urlError))
            return
        }
        // cancel previous task
        task?.cancel()
        // set current tast with a session datatask for the current request
        // returns data, a responses status and and eventually an error
        task = session.dataTask(with: request) { (data, response, error) in
            // run the rest of the code in the main thread
            DispatchQueue.main.async {
                // Check if there is an error
                if let error = error {
                    completion(.failure(.requestError(error)))
                    return
                }
                // Unwrap data optional
                guard let data = data else {
                    completion(.failure(.dataError))
                    return
                }
                // check if the response is valid
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.responseError))
                    return
                }
                // check if the response code is 200 or return an error.
                guard response.statusCode == 200 else {
                    completion(.failure(.httpError(response.statusCode)))
                    return
                }
                // do/catch block for trying to decode data returned from session dataTask
                do {
                    let responseJSON = try JSONDecoder().decode(Translation.self, from: data)
                    // return decoded JSON
                    completion(.success(responseJSON))
                } catch {
                    // return an error in case of failure decoding JSON
                    completion(.failure(.decodingData))
                }
            }
        }
        // start the task
        task?.resume()
    }
}
