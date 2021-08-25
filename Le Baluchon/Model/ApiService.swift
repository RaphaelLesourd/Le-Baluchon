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
    /// - Parameters:
    ///   - request: URLRequest for data requested
    ///   - completion: Returns a Result  succes case:  decoded JSON  or failure case: ApiError message
    func getData<T: Decodable>(with url: URL?, completion: @escaping (Result<T, ApiError>) -> Void) {

        guard let url = url else {
            completion(.failure(.urlError))
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.dataError))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.responseError))
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(responseJSON))
                } catch {
                    completion(.failure(.decodingData))
                }
            }
        }
        task?.resume()
    }
}



