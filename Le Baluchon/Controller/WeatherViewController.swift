//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Properties
    let weatherView = WeatherMainView()
    // MARK: - Lifecycle

    /// Set the view as rateView.
    /// All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = weatherView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocalWeatherView()
        updateDestinationWeatherView()
        updateDestinationWeatherInfoView()
    }

    // MARK: - Update views
    // update local weather
    private func updateLocalWeatherView() {
        let localWeather = weatherView.localWeatherView
        localWeather.cityLabel.text = "La Rochelle"
        localWeather.countryLabel.text = "France"
        localWeather.temperatureLabel.text = "35°"
        localWeather.weatherIcon.image = #imageLiteral(resourceName: "sunny_color")
    }
    // update destination weather
    private func updateDestinationWeatherView() {
        let destinationWeather = weatherView.destinationWeatherView
        destinationWeather.cityLabel.text = "New York, Etats-Unis"
        destinationWeather.temperatureLabel.text = "12°"
        destinationWeather.conditionsLabel.text = "Orages"
        destinationWeather.weatherIcon.image = #imageLiteral(resourceName: "thunder_sunny_color")
    }
    // update destination extended weather
    private func updateDestinationWeatherInfoView() {
        let weatherInfo = weatherView.destinationWeatherInfoView
        weatherInfo.directionView.valueLabel.text = "33°"
        weatherInfo.windView.valueLabel.text = "16km/h"
        weatherInfo.visiblityView.valueLabel.text = "4km"
        weatherInfo.cloudView.valueLabel.text = "90%"
        weatherInfo.pressureView.valueLabel.text = "1019hpa"
        weatherInfo.humidityView.valueLabel.text = "75%"
    }
}
