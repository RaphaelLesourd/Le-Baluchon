//
//  ApiErrors.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

enum ApiError: LocalizedError {
    case errorFetching
    case httpError(Int)
    case decodingData

    var description: String {
        switch self {
        case .errorFetching:
            return "Nous avons rencontré un problème pour récupérer les données."
        case .httpError(let code):
            return "\(code)"
        case .decodingData:
            return "Format de données non valide."
        }
    }
}
