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
                        completion: @escaping (Foundation.Data) -> Void) {

        guard let request = createRequest(for: imageName) else {return}

        task = session.dataTask(with: request) { (data, response, error) in
            // run the rest of the code in the main thread
            DispatchQueue.main.async {
                // Unwrap data optional
                guard let data = data, error == nil else {return}
                // check if the response is valid
                guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
                    return
                }
                completion(data)
            }
        }
        // start the task
        task?.resume()
    }

    // MARK: - Network call
    /// Creates url request for fetching all currencies
    /// - Returns: URLRequest
    private func createRequest(for imageName: String) -> URLRequest? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "openweathermap.org"
        urlComponents.path = "/img/wn/\(imageName)@2x.png"
        guard let url = urlComponents.url else {
            return nil
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
