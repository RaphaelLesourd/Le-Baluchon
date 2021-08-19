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
    case decodingData
}
extension ApiError {
    var description: String {
        switch self {
        case .urlError:
            return "Données non trouvées."
        case .responseError:
            return "Nous avons rencontré une erreur avec le serveur"
        case .dataError:
            return "Il y a une erreur avec les données."
        case .decodingData:
            return "Format de données non valide."
        }
    }
}

enum ConversionError: Error {
    case zeroDivision
    case calculation
    case format
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
        }
    }
}
