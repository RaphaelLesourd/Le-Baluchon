//
//  ApiErrors.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

enum ApiError: Error {
    case errorFetching
    case httpError
    case decodingData

    var description: String {
        switch self {
        case .errorFetching:
            return "Nous avons rencontré un problème pour récupérer les données."
        case .httpError:
            return "Erreur de réseau, verifiez que vous êtes bien connecté."
        case .decodingData:
            return "Format de données non valide."
        }
    }
}

enum ConversionError: Error {
    case zeroDivision
    case calculation

    var description: String {
        switch self {
        case .zeroDivision:
            return "Veuillez entrer un montant superieur à zero."
        case .calculation:
            return "Nous avons rencontré une erreur de conversion."
        }
    }
}
