//
//  WeatherCalculations.swift
//  LeBaluchon
//
//  Created by Birkyboy on 20/08/2021.
//

import Foundation

class WeatherCalculations {

    var currentTime = Date().dateToMiliseconds()

    /// Calculate progressfrom 0 to 1 betwwen 2 timeStamp
    /// - Parameters:
    ///   - startTime: sunrise timeStamp from Weather model
    ///   - endTime: sunset timeStamp from Weather model
    /// - Returns: float as progress value
    func calculateSunProgress(with startTime: Int?, and endTime: Int?) -> Float {
        guard let startTime = startTime else {
            return 0
        }
        guard let endTime = endTime else {
            return 0
        }

        let floatCurrentTime = Float(currentTime)
        let floatStartTime = Float(startTime)
        let floatEndTime = Float(endTime)
        
        guard floatCurrentTime > floatStartTime else {
            return 0
        }
        guard floatCurrentTime < floatEndTime else {
            return 1.0
        }
        return ((floatCurrentTime - floatStartTime) / (floatEndTime - floatStartTime))
    }

    /// Convert a double value to a formatted string.
    /// - Parameter speed: Double value from Weather model.
    /// - Returns: String of wind speed  in km/h and unit.
    func convertToKmPerHourString(_ speed: Double?) -> String {
        guard let speed = speed else {
            return "--"
        }
        let speedInKmPerHour = speed * 3.6
        return speedInKmPerHour.toString(decimals: 0) + " km/h"
    }

    /// convert a Int value to formatted string.
    /// - Parameter distance: Int value from Weeather model.
    /// - Returns: String of visibility distance in km and unit.
    func convertToKilometerString(_ distance: Int?) -> String {
        guard let distance = distance else {
            return "--"
        }
        return "\(distance / 1000) km"
    }

    /// Calculate and display formatted time.
    /// - Parameters:
    ///   - timeStamp: Int value of sunset ot sunrise time from Weather model.
    ///   - timeDifference: Int value of time difference from Weather model.
    /// - Returns: Time plus timedifference converted to Date as String
    func calculateTimeFromTimeStamp(with timeStamp: Int?, and timeDifference: Int?) -> String {
        guard let timeStamp = timeStamp else {
            return "--"
        }
        guard let timeDifference = timeDifference else {
            return "--"
        }
        let sunriseTime = (timeStamp + timeDifference).toDate()
        return sunriseTime.toString(with: .timeOnly)
    }
}
