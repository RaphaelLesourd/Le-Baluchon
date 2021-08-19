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
                        from orgin: String,
                        to target: String,
                        completion: @escaping (Result<Translation, ApiError>) -> Void) {
        // set current request returned from the createRequest method.
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "format", value: "text"),
            URLQueryItem(name: "source", value: orgin),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "key", value: ApiKeys.googleTranslateKey)
        ]

        apiService.getData(for: Translation.self, with: urlComponents.url) { result in
            switch result {
            case .success(let translation):
                completion(.success(translation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
