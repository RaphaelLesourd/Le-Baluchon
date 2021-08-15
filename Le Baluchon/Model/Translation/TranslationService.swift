//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

class TranslationService {

    func getTranslation(for text: String,
                        from orgin: String,
                        to target: String,
                        completion: @escaping (Result<Translation, ApiError>) -> Void) {
        // set current request returned from the createRequest method.
        guard let request = createRequest(with: text, from: orgin, to: target) else {
            completion(.failure(.urlError))
            return
        }
        ApiService.shared.getData(for: Translation.self, request: request) { result in
            switch result {
            case .success(let translation):
                completion(.success(translation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createRequest(with text: String,
                               from orgin: String,
                               to target: String) -> URLRequest? {

        let endPoint = "?q=\(text.httpFormat)&format=text&source=\(orgin)&target=\(target)&key="
        let url = ApiURL.googleTranslateURL + endPoint + ApiKeys.googleTranslateKey

        guard let rateURL = URL(string: url) else {
            return nil
        }
        var request = URLRequest (url: rateURL)
        request.httpMethod = "GET"
        return request
    }
}
