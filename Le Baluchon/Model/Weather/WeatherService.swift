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

    private static let currenciesUrl = URL(string: ApiURL.openWeatherMapURL)!
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(_ weatherURL: URL) -> URLRequest {
        var request = URLRequest(url: weatherURL)
        request.httpMethod = "GET"
        return request
    }

    /// Fetch data from API
    ///
    /// - Parameter completion: Returns a Result.
    /// - Succes case:  currency list dictionary.
    /// - Error case :  Error of type ApiError.
    func getData(for city: String,
                     completion: @escaping (Result<Weather, ApiError>) -> Void) {

        guard let formattedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        guard let weatherURL = URL(string: ApiURL.openWeatherMapURL + "weather?q=\(formattedCity)&units=metric&lang=fr&appid=" + ApiKeys.openWeatherKEY) else {
            completion(.failure(.urlError))
            return
        }

        let request = createRequest(weatherURL)
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

    func getWeatherIcon(imageCode: String,
                         completion: @escaping (Result<Data, ApiError>) -> Void) {
        let url = URL(string: "http://openweathermap.org/img/wn/" + imageCode + "@2x.png")!
         task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestError(error)))
                    return
                }
                guard let data = data else {
                    completion(.failure(.decodingData))
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
                print(data)
                completion(.success(data))
            }
        }
        task?.resume()
    }
}
