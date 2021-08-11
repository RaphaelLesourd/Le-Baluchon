//
//  Weather.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation

struct Weather: Decodable {
    let weather: [WeatherElement]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
}

struct Clouds: Decodable {
    let all: Int
}

struct Main: Decodable {
    let temp: Double
    let pressure, humidity: Int
}

struct WeatherElement: Decodable {
    let id: Int
    let weatherDescription: String
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}
