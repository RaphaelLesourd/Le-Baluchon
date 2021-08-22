//
//  GeocodeManager.swift
//  PhotoLocation
//
//  Created by Birkyboy on 08/04/2021.
//

import Foundation
import CoreLocation

class GeocodeManager {

    static let shared = GeocodeManager()

    func getCityName(for location: CLLocation,
                     completion: @escaping (Result<String, ApiError>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.responseError))
                    return
                }
                if let cityName = placemarks?.first?.locality {
                    completion(.success(cityName))
                }
            }
        })
    }
}
