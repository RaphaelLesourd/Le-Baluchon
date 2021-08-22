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
    private var geocoder = CLGeocoder()

    func getCityName(for location: CLLocation?,
                     completion: @escaping (Result<String, GeocodingError>) -> Void) {

        guard let location = location else {
            completion(.failure(.invalidCoordinates))
            return
        }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.locationNotFound))
                    return
                }
                if let cityName = placemarks?.first?.locality {
                    completion(.success(cityName))
                }
            }
        })
    }
}
