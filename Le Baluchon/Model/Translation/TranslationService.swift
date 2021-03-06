//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class TranslationService {

    var apiService = ApiService.shared

    func getTranslation(for text: String,
                        from origin: String,
                        to target: String,
                        completion: @escaping (Result<Translation, ApiError>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "format", value: "text"),
            URLQueryItem(name: "source", value: origin),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "key", value: ApiKeys.googleTranslateKey)
        ]
        apiService.getData(with: urlComponents.url) { (result: Result<Translation, ApiError>) in
            completion(result)
        }
    }
}
