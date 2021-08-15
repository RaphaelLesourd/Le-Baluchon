//
//  Weatherservice.swift
//  Le Baluchon
//
//  Created by Birkyboy on 12/08/2021.
//

import Foundation

class WeatherService {

    func getWeather(for city: String,
                        completion: @escaping (Result<Weather, ApiError>) -> Void) {
        guard let request = createRequest(for: city) else {
            return
        }
        ApiService.shared.getData(for: Weather.self, request: request) { result in
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

        let endPoint = "weather?q=\(city.httpFormat)&units=metric&lang=fr&appid="
        guard let weatherURL = URL(string: ApiURL.openWeatherMapURL + endPoint + ApiKeys.openWeatherKEY) else {
            return nil
        }
        var request = URLRequest(url: weatherURL)
        request.httpMethod = "GET"
        return request
    }
}
