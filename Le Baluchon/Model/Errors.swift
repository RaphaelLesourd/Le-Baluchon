//
//  ApiErrors.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

enum ApiError: Error {
    case urlError
    case dataError
    case responseError
    case httpError(Int)
    case decodingData
}
extension ApiError {
    var description: String {
        switch self {
        case .urlError:
            return "Données non trouvées."
        case .responseError:
            return "Nous avons rencontré une erreur dans la réponse du serveur"
        case .httpError(let code):
            return decodeHttpError(for: code)
        case .dataError:
            return "Il y a une erreur avec les données."
        case .decodingData:
            return "Format de données non valide."
        }
    }

    private func decodeHttpError(for code: Int) -> String {
        switch code {
        case 400:
            return "La syntaxe de la requête est erronée."
        case 403:
            return "Limite d'utilisation dépassée."
        case 401:
            return "Accès refusé."
        case 404:
            return "Non trouvé"
        case 408:
            return "Temps d'attente d'une réponse du serveur écoulé"
        case 500:
            return "Erreur interne du serveur"
        case 503:
            return "Service indisponible"
        default:
            return "Nous avons rencontré un problème avec le serveur."
        }
    }
}

enum ConversionError: Error {
    case zeroDivision
    case calculation
    case format
    case noAmount
}
extension ConversionError {
    var description: String {
        switch self {
        case .zeroDivision:
            return "Veuillez entrer un montant superieur à zero."
        case .calculation:
            return "Nous avons rencontré une erreur de conversion."
        case .format:
            return "Vous avez essayé de mettre deux fois la virgule."
        case .noAmount:
            return "Veuiller entrer un montant."
        }
    }
}
