//
//  Weatherservice.swift
//  Le Baluchon
//
//  Created by Birkyboy on 12/08/2021.
//

import Foundation

class WeatherService {

    static let shared = WeatherService()
    private init() {}

    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(for city: String) -> URLRequest? {
        guard let weatherURL = URL(string: ApiURL.openWeatherMapURL + "weather?q=\(city.formattedForHttpRequest)&units=metric&lang=fr&appid=" + ApiKeys.openWeatherKEY) else {
            return nil
        }
        var request = URLRequest(url: weatherURL)
        request.httpMethod = "GET"
        return request
    }

    /// Fetch data from API
    /// - Parameter completion: Returns a Result.
    /// - Succes case:  currency list dictionary.
    /// - Error case :  Error of type ApiError.
    func getData(for city: String,
                     completion: @escaping (Result<Weather, ApiError>) -> Void) {

        guard let request = createRequest(for: city) else {
            completion(.failure(.urlError))
            return
        }
    //    task?.cancel()
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
                    completion(.failure(.httpError(0)))
                    return
                }
                guard response.statusCode == 200 else {
                    completion(.failure(.httpError(response.statusCode)))
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(Weather.self, from: data)
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
