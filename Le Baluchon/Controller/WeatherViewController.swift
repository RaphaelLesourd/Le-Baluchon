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
    private let weatherIconParser = WeatherIconParser()
    private var localWeather: Weather? {
        didSet {
            guard let localWeather = localWeather else {return}
            updateLocalWeatherView(with: localWeather)
        }
    }
    private var destinationWeather: Weather? {
        didSet {
            guard let destinationWeather = destinationWeather else {return}
            updateDestinationWeatherView(with: destinationWeather)
            updateDestinationWeatherInfoView(with: destinationWeather)
        }
    }
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
        let localWeather = weatherView.localWeatherView
        localWeather.cityLabel.text = "La Rochelle"
        localWeather.countryLabel.text = "France"
        let iconImage = weatherIconParser.setWeatherIcon(for: 200)
        let destinationWeather = weatherView.destinationWeatherView
        destinationWeather.weatherIcon.image = UIImage(named: iconImage)
    }

    // MARK: - Fetch Data
    

    // MARK: - Update views
    // update local weather
    private func updateLocalWeatherView(with weather: Weather) {
        let localWeather = weatherView.localWeatherView
        localWeather.temperatureLabel.text = "\(weather.main.temp)°"
        let iconImage = weatherIconParser.setWeatherIcon(for: weather.weather[0].id)
        localWeather.weatherIcon.image = UIImage(named: iconImage)
    }
    // update destination weather
    private func updateDestinationWeatherView(with weather: Weather) {
        let destinationWeather = weatherView.destinationWeatherView
        destinationWeather.cityLabel.text = "New York, Etats-Unis"
        destinationWeather.temperatureLabel.text = "\(weather.main.temp)°"
        destinationWeather.conditionsLabel.text = "\(weather.weather[0].weatherDescription)".capitalized
        let iconImage = weatherIconParser.setWeatherIcon(for: weather.weather[0].id)
        destinationWeather.weatherIcon.image = UIImage(named: iconImage)
    }
    // update destination extended weather
    private func updateDestinationWeatherInfoView(with weather: Weather) {
        let weatherInfo = weatherView.destinationWeatherInfoView
        weatherInfo.directionView.valueLabel.text = "\(weather.wind.deg)°"
        weatherInfo.windView.valueLabel.text = "\(weather.wind.speed)km/h"
        weatherInfo.visiblityView.valueLabel.text = "\(weather.visibility)km"
        weatherInfo.cloudView.valueLabel.text = "\(weather.clouds.all)%"
        weatherInfo.pressureView.valueLabel.text = "\(weather.main.pressure)hpa"
        weatherInfo.humidityView.valueLabel.text = "\(weather.main.humidity)%"
    }
}
