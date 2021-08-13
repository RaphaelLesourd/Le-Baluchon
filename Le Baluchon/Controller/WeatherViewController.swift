//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Properties
    private enum cityType {
        case local
        case destination
    }

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
        setRefresherControl()
        getData()
    }
    // MARK: - Setup
    /// Adds a refreshed to the scrollView, trigger a neworl call to fetch latest exchange rate.
    private func setRefresherControl() {
        weatherView.scrollView.refreshControl = weatherView.refresherControl
        weatherView.refresherControl.addTarget(self, action: #selector(getData), for: .valueChanged)
    }

    // MARK: - Fetch Data

    @objc private func getData() {
        getWeatherData(of: "Paris") { [weak self] weather in
            self?.localWeather = weather
            self?.getWeatherData(of: "New york") { [weak self] weather in
                self?.destinationWeather = weather
            }
        }
    }

    private func getWeatherData(of city: String, completion: @escaping (Weather) -> Void) {
        WeatherService.shared.getRateData(for: city) { [weak self] result in
            guard let self = self else {return}
            self.weatherView.refresherControl.perform(#selector(UIRefreshControl.endRefreshing),
                                                      with: nil,
                                                      afterDelay: 0.1)
            switch result {
            case .success(let weather):
                completion(weather)
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }

    // MARK: - Update views
    // update local weather
    private func updateLocalWeatherView(with weather: Weather) {
        let localWeather = weatherView.localWeatherView
        if let city = weather.name, let country = weather.sys?.country {
            localWeather.cityLabel.text = "\(city), \(country)"
        }
        if let temperature = weather.main?.temp {
            localWeather.temperatureLabel.text = "\(temperature.formatted(decimals: 0))°"
        }
        if let weatherIcon = weather.weather?[0].id {
            let iconImage = weatherIconParser.setWeatherIcon(for: weatherIcon)
            localWeather.weatherIcon.image = UIImage(named: iconImage)
        }
    }

    // update destination weather
    private func updateDestinationWeatherView(with weather: Weather) {
        let destinationWeather = weatherView.destinationWeatherView
        if let city = weather.name, let country = weather.sys?.country {
            destinationWeather.cityLabel.text = "\(city), \(country)"
        }
        if let temperature = weather.main?.temp {
            destinationWeather.temperatureLabel.text = "\(temperature.formatted(decimals: 0))°"
        }
        if let weatherCondition = weather.weather?[0].description {
            destinationWeather.conditionsLabel.text = "\(weatherCondition)".capitalized
        }
        if let weatherIcon = weather.weather?[0].id {
            let iconImage = weatherIconParser.setWeatherIcon(for: weatherIcon)
            destinationWeather.weatherIcon.image = UIImage(named: iconImage)
        }

    }
    // update destination extended weather
    private func updateDestinationWeatherInfoView(with weather: Weather) {
        let weatherInfo = weatherView.destinationWeatherInfoView
        if let windDirection = weather.wind?.deg {
            weatherInfo.directionView.valueLabel.text = "\(windDirection)°"
        }
        if let windSpeed = weather.wind?.speed {
            let speedInKmPerHour = windSpeed * 3.6
            weatherInfo.windView.valueLabel.text = speedInKmPerHour.formatted(decimals: 0) + "km/h"
        }
        if let visibility = weather.visibility {
            weatherInfo.visiblityView.valueLabel.text = "\(visibility / 1000)km"
        }
        if let cloudCoverage = weather.clouds?.all {
            weatherInfo.cloudView.valueLabel.text = "\(cloudCoverage)%"
        }
        if let pressure = weather.main?.pressure {
            weatherInfo.pressureView.valueLabel.text = "\(pressure)hpa"
        }
        if let humidity = weather.main?.humidity {
            weatherInfo.humidityView.valueLabel.text = "\(humidity)%"
        }
    }
}
