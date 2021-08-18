//
//  APIService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 15/08/2021.
//

import Foundation

class ApiService {

    // MARK: - Properties
    static let shared = ApiService()
    private init() {}

    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    /// Fetch data from API
    /// - Note: Function taking a generic decodable data object.
    /// - Any previous URLSessionDataTask get cancelled for each request except if the Data model is Weather.
    /// - Parameters:
    ///   - for: Any Decodable object.
    ///   - request: URLRequest for data requested
    ///   - completion: Returns a Result  succes case:  decoded JSON  or failure case: ApiError message
    func getData<T: Decodable>(for: T.Type = T.self,
                               with request: URLRequest?,
                               completion: @escaping (Result<T, ApiError>) -> Void) {
        // cancel previous task
        if T.self != Weather.self {
            task?.cancel()
        }
        // set current task with a session datatask for the request
        // returns data, a responses status and error
        guard let request = request else {return}
        task = session.dataTask(with: request) { (data, response, error) in
            // run the rest of the code in the main thread
            DispatchQueue.main.async {
                // Unwrap data optional
                guard let data = data, error == nil else {
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
                // do/catch block trying to decode data returned from session dataTask
                do {
                    let responseJSON = try JSONDecoder().decode(T.self, from: data)
                    // return decoded JSON
                    completion(.success(responseJSON))
                } catch {
                    // return an error in case JSONDecoder throw ne error
                    completion(.failure(.decodingData))
                }
            }
        }
        // start the task
        task?.resume()
    }
}



