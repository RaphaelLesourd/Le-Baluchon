//
//  Weatherservice.swift
//  Le Baluchon
//
//  Created by Birkyboy on 12/08/2021.
//

import Foundation

class WeatherService {

    var apiService = ApiService.shared

    func getWeather(for city: String,
                        completion: @escaping (Result<Weather, ApiError>) -> Void) {
        let request = createRequest(for: city)
        apiService.getData(for: Weather.self, with: request) { result in
            switch result {
            case .success(let weather):
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(for city: String) -> URLRequest? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "appid", value: ApiKeys.openWeatherKEY)
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
