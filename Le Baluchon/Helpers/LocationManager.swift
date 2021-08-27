//
//  LocationManager.swift
//  PhotoLocation
//
//  Created by Birkyboy on 02/04/2021.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func presentError(with error: String)
}

class LocationService: NSObject {

    var locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other
    }
  
    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .denied:
                delegate?.presentError(with: "Le Baluchon n'est pas autorisé à utiliser votre position.")
            case .authorizedAlways, .authorizedWhenInUse:
                startUpdatingLocation()
            default:
                break
            }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        delegate?.presentError(with: error.localizedDescription)
    }
}
