//
//  WeatherIconService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 17/08/2021.
//

import Foundation

class WeatherIconService {

    static let shared = WeatherIconService()
    private init() {}

    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }

    func getWeatherIcon(for imageName: String,
                        completion: @escaping (Result<Data, ApiError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "openweathermap.org"
        urlComponents.path = "/img/wn/\(imageName)@2x.png"

        requestWeatherIcon(with: urlComponents.url) { result in
            completion(result)
        }
    }

    func requestWeatherIcon(with url: URL?, completion: @escaping (Result<Data, ApiError>) -> Void) {
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
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200  else {
                    completion(.failure(.responseError))
                    return
                }
                completion(.success(data))
            }
        }
        task?.resume()
    }
}
