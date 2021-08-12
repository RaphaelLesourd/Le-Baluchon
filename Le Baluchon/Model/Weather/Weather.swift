//
//  Weather.swift
//  Le Baluchon
//
//  Created by Birkyboy on 10/08/2021.
//

import Foundation

struct Weather: Decodable {
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let sys: Sys?
    let name: String?
}

struct Clouds: Decodable {
    let all: Int?
}

struct Main: Decodable {
    let temp: Double?
    let pressure, humidity: Int?
}

struct Sys: Decodable {
    let type, id: Int?
    let country: String?
}

struct WeatherElement: Decodable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
