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

        apiService.getData(for: Weather.self, with: urlComponents.url) { result in
            switch result {
            case .success(let weather):
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
