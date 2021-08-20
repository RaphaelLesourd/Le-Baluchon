//
//  WeatherCalculations.swift
//  LeBaluchon
//
//  Created by Birkyboy on 20/08/2021.
//

import Foundation

class WeatherCalculations {

    var currentTime = Date().dateToMiliseconds()

    func calculateSunProgress(with startTime: Int, and endTime: Int) -> Float {

        let floatCurrentTime = Float(currentTime)
        let floatStartTime = Float(startTime)
        let floatEndTime = Float(endTime)
        
        guard floatCurrentTime > floatStartTime else {
            return 1.0
        }
        guard floatCurrentTime < floatEndTime else {
            return 1.0
        }
        return ((floatCurrentTime - floatStartTime) / (floatEndTime - floatStartTime))
    }
}
