//
//  WeatherIconParser.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation

class WeatherIconParser {
  
    func setWeatherIcon(for code: Int) -> String {
        switch code {
        case 200, 230:
            return "thunder_sunny_color"
        case 201, 202, 210, 211, 212, 221, 231, 232:
            return "thunder_color"
        case 300, 301, 302, 310, 311, 312, 313, 314, 321:
            return "rain_sunny_color"
        case 500, 520:
            return "rain_light_color"
        case 501, 502, 503, 504, 511, 521, 522, 531:
            return "rain_heavy_color"
        case 600, 601, 611, 612, 613, 615, 616, 620:
            return "snow_light_color"
        case 602, 621, 622:
            return "snow_heavy_color"
        case 701, 711, 721, 731, 741, 751, 761, 762, 771, 781:
            return "cloudy_foggy_color"
        case 800:
            return "sunny_color"
        case 801, 802, 803, 804:
            return "cloudy_sunny_color"
        default:
            return "night_color"
        }
    }
}
