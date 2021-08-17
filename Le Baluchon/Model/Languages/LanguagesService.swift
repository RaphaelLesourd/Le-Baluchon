//
//  LanguagesService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class LanguagesService {

    func getLanguages(completion: @escaping (Result<Languages, ApiError>) -> Void) {

        guard let request = createRequest() else {
            completion(.failure(.urlError))
            return
        }
        ApiService.shared.getData(for: Languages.self, request: request) { result in
            switch result {
            case .success(let languages):
                completion(.success(languages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createRequest() -> URLRequest? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2/languages"
        urlComponents.queryItems = [
            URLQueryItem(name: "target", value: "fr"),
            URLQueryItem(name: "key", value: ApiKeys.googleTranslateKey)
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
