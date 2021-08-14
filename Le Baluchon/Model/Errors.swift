//
//  ApiErrors.swift
//  Le Baluchon
//
//  Created by Birkyboy on 08/08/2021.
//

import Foundation

enum ApiError: Error {
    case urlError
    case requestError(Error)
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
        case .requestError(let error):
            return error.localizedDescription
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
        case 401, 403:
            return "Accès à la ressource refusé."
        case 404:
            return "Non trouvé, êtes vous sur que cela existe?"
        case 406:
            return "Toutes les réponses envisageables seront refusées."
        case 408:
            return "Temps d'attente d'une réponse du serveur écoulé"
        case 413:
            return "Traitement abandonné dû à une requête trop importante"
        case 500:
            return "Erreur interne du serveur"
        case 502:
            return "Mauvaise réponse envoyée à un serveur intermédiaire par un autre serveur."
        case 503:
            return "Service indisponible"
        case 504:
            return "Temps d'attente d'une réponse d'un serveur à un serveur intermédiaire écoulé"
        default:
            return ""
        }
    }
}

enum ConversionError: Error {
    case zeroDivision
    case calculation
    case format
    case zeroAmount
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
        case .zeroAmount:
            return "Veuiller entrer un montant superieur à zéro."
        }
    }
}
