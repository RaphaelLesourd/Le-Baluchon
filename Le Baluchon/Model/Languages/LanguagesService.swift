//
//  LanguagesService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class LanguagesService {

    static let shared = LanguagesService()
    private init() {}

    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest() -> URLRequest? {
        guard let url = URL(string: ApiURL.googleTranslateURL + "/languages?target=fr&key=" + ApiKeys.googleTranslateKey) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(url)
        return request
    }
    /// Fetch data from API
    ///
    /// - Parameter completion: Returns a Result.
    /// - Succes case:  currency list dictionary.
    /// - Error case :  Error of type ApiError.
    func getData(completion: @escaping (Result<Languages, ApiError>) -> Void) {
        // set current request returned from the createRequest method.
        guard let request = createRequest() else {
            completion(.failure(.urlError))
            return
        }
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
                    let responseJSON = try JSONDecoder().decode(Languages.self, from: data)
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
