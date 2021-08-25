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
    private init() {}
    
    private var geocoder = CLGeocoder()

    /// Get the city name from GPS coordinates by using le locality property of a placemark returned from geocodeer reverseGeocodeLocation.
    /// - Parameters:
    ///   - location: CLLocation coordinates
    ///   - completion: Result  city name, error.
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
