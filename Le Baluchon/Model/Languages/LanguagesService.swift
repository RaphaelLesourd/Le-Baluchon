//
//  LanguagesService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class LanguagesService {

    var apiService = ApiService.shared

    func getLanguages(completion: @escaping (Result<Languages, ApiError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2/languages"
        urlComponents.queryItems = [
            URLQueryItem(name: "target", value: "fr"),
            URLQueryItem(name: "key", value: ApiKeys.googleTranslateKey)
        ]
        apiService.getData(with: urlComponents.url) { (result: Result<Languages, ApiError>) in
            completion(result)
        }
    }
}
