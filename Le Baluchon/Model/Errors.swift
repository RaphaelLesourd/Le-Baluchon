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
            return "Données introuvable."
        case .responseError:
            return "Impossible de contacter le serveur."
        case .dataError:
            return "Nous n'avons pas pu recupérer les données."
        case .decodingData:
            return "Format de données non valide."
        }
    }
}

enum ConversionError: Error {
    case calculation
    case format
    case noData
}
extension ConversionError {
    var description: String {
        switch self {
        case .calculation:
            return "Nous avons rencontré une erreur de conversion."
        case .format:
            return "Vous avez essayé de mettre deux fois la virgule."
        case .noData:
            return "Veuillez entrer un montant à convertir."
        }
    }
}
