//
//  Weatherservice.swift
//  Le Baluchon
//
//  Created by Birkyboy on 12/08/2021.
//

import Foundation

class WeatherService {

    var apiService = ApiService.shared
    var lang = Locale.current.regionCode?.lowercased()

    func getWeather(for city: String, completion: @escaping (Result<Weather, ApiError>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "\(lang ?? "en")"),
            URLQueryItem(name: "appid", value: ApiKeys.openWeatherKEY)
        ]
        apiService.getData(with: urlComponents.url) { (result: Result<Weather, ApiError>) in
            completion(result)
        }
    }
}
