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
    func calculateSunProgress(with startTime: Int, and endTime: Int) -> Float {
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


    /// Calculate and display formatted time.
    /// - Parameters:
    ///   - timeStamp: Int value of sunset ot sunrise time from Weather model.
    ///   - timeDifference: Int value of time difference from Weather model.
    /// - Returns: Time plus timedifference converted to Date as String
    func calculateTimeFromTimeStamp(with timeStamp: Int, and timeDifference: Int) -> String {
        let sunriseTime = (timeStamp + timeDifference).toDate()
        return sunriseTime.toString(with: .timeOnly)
    }
}
