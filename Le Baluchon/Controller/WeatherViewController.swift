//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Properties
    private let weatherView = WeatherMainView()
    private let weatherService = WeatherService()
    private var localWeather: Weather?
    private var destinationWeather: Weather?
    private let userIcon = true
    private var searchBarButtonTap = true

    private var localWeatherIcon: Foundation.Data? {
        didSet {
            guard let localWeatherIcon = localWeatherIcon else {return}
            weatherView.localWeatherView.weatherIcon.image = UIImage(data: localWeatherIcon)
        }
    }
    private var destinationWeatherIcon: Foundation.Data? {
        didSet {
            guard let destinationWeatherIcon = destinationWeatherIcon else {return}
            weatherView.destinationWeatherView.weatherIcon.image = UIImage(data: destinationWeatherIcon)
        }
    }
    private var destinationCityName = "New york" {
        didSet{
            getWeatherData()
        }
    }
    // Set the view as rateView.
    // All UI elements are contained in a seperate UIView file.
    override func loadView() {
        view = weatherView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherView.searchBar.delegate = self
        addKeyboardDismissGesture()
        setSearchBarButtonTarget()
        setRefresherControl()
        getWeatherData()
    }

    // MARK: - Setup
    /// Adds a refreshed to the scrollView, trigger a neworl call to fetch latest exchange rate.
    private func setRefresherControl() {
        weatherView.scrollView.refreshControl = weatherView.refresherControl
        weatherView.refresherControl.addTarget(self, action: #selector(getWeatherData),
                                               for: .valueChanged)
    }

    private func setSearchBarButtonTarget() {
        weatherView.destinationWeatherView.searchButton.addTarget(self,
                                                                  action: #selector(searchBarButtonTapped),
                                                                  for: .touchUpInside)
    }


    // MARK: - Fetch Data
    /// Get weather data for local and destination city.
    ///  - Note: Usage of DispatchGroup() to avoid nested API calls, iimplementing this  processes  to wait for all calls
    ///  to complete before doing the next thing,
    /// - Create a dispatchGRoup object
    /// - Enter the function
    /// - Excute the task
    /// - Leave the the function when the task is completed
    /// - Once all entered calls are left, it will call the closure passed to `notify(queue: .main)` and will to display all weather data at the same time.
    @objc private func getWeatherData() {
        let dispatchGroup = DispatchGroup()
        // Start refreshIndicator
        toggleActiviyIndicator(for: weatherView.headerView.activityIndicator, shown: true)
        // Local weather
        dispatchGroup.enter()
        getWeather(for: "Paris") { [weak self] weather in
            self?.localWeather = weather
            dispatchGroup.leave()
        }
        // Destination weather
        dispatchGroup.enter()
        getWeather(for: self.destinationCityName) { [weak self] weather in
            self?.destinationWeather = weather
            dispatchGroup.leave()
        }
        // display weather
        dispatchGroup.notify(queue: .main) {
            if let localWeather = self.localWeather {
                self.updateLocalWeatherView(with: localWeather)
            }
            if let destinationWeather = self.destinationWeather {
                self.updateDestinationWeatherView(with: destinationWeather)
                self.updateDestinationWeatherInfoView(with: destinationWeather)
            }
        }
    }
    /// Get weather data from API.
    /// - Parameters:
    ///   - city: city name.
    ///   - completion: Weather object
    private func getWeather(for city: String,
                                      completion: @escaping (Weather) -> Void) {

        weatherService.getWeather(for: city) { [weak self] result in
            guard let self = self else {return}
            self.stopRefresherActivityControls()
            switch result {
            case .success(let weather):
                completion(weather)
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }
    private func stopRefresherActivityControls() {
        self.toggleActiviyIndicator(for: self.weatherView.headerView.activityIndicator,
                                    shown: false)
        self.weatherView.refresherControl.perform(#selector(UIRefreshControl.endRefreshing),
                                                  with: nil,
                                                  afterDelay: 0.1)
    }

    // MARK: - Update views

    // Local Weather

    /// Update local weather view with `Weather`object data
    /// - Parameter weather: Local `Weather` object.
    private func updateLocalWeatherView(with weather: Weather) {
        let localWeather = weatherView.localWeatherView
        if let city = weather.name,
           let country = weather.sys?.country?.countryName {
            localWeather.cityLabel.text = "\(city), \(country)"
        }
        if let temperature = weather.main?.temp {
            localWeather.temperatureLabel.text = "\(temperature.toString(decimals: 0))°"
        }
        if let weatherIcon = weather.weather?[0].icon {
            if userIcon {
                localWeather.weatherIcon.image = UIImage(named: weatherIcon)
                return
            }
            WeatherIconService.shared.getWeatherIcon(for: weatherIcon) { [weak self] data in
                guard let self = self else {return}
                self.localWeatherIcon = data
            }
        }
    }

    // Destination Weather

    /// Update destination weather view with `Weather`object data
    /// - Parameter weather: Destination `Weather`object.
    private func updateDestinationWeatherView(with weather: Weather) {
        let destinationWeather = weatherView.destinationWeatherView
        if let city = weather.name,
           let country = weather.sys?.country?.countryName {
            destinationWeather.cityLabel.text = "\(city),\n\(country)"
        }
        if let temperature = weather.main?.temp {
            destinationWeather.temperatureLabel.text = "\(temperature.toString(decimals: 0))°"
        }
        if let weatherCondition = weather.weather?[0].description {
            destinationWeather.conditionsLabel.text = "\(weatherCondition)".capitalized
        }
        if let weatherIcon = weather.weather?[0].icon {
            if userIcon {
                destinationWeather.weatherIcon.image = UIImage(named: weatherIcon)
                return
            }
            WeatherIconService.shared.getWeatherIcon(for: weatherIcon) {  [weak self] data in
                guard let self = self else {return}
                self.destinationWeatherIcon = data
            }
        }
    }

    // Destination Extended Weather
    
    /// Update destination weather extended info  view with `Weather`object data
    /// - Parameter weather: Destination `Weather`object.
    private func updateDestinationWeatherInfoView(with weather: Weather) {
        let weatherInfo = weatherView.destinationWeatherInfoView
        if let windDirection = weather.wind?.deg {
            weatherInfo.directionView.valueLabel.text = "\(windDirection)°"
        }
        if let windSpeed = weather.wind?.speed {
            let speedInKmPerHour = windSpeed * 3.6
            weatherInfo.windView.valueLabel.text = speedInKmPerHour.toString(decimals: 0) + "km/h"
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

    // MARK: - Search Bar
    @objc private func searchBarButtonTapped() {
        let height: SearchBarHeight = searchBarButtonTap ? .expanded : .collapsed
        animateSearchBar(for: height)
        searchBarButtonTap.toggle()
        weatherView.searchBar.text = nil
    }
    private func animateSearchBar(for height: SearchBarHeight) {
        weatherView.searchBarHeightConstraint.isActive = false
        weatherView.searchBarHeightConstraint = weatherView.searchBar.heightAnchor.constraint(equalToConstant: height.rawValue)
        weatherView.searchBarHeightConstraint.isActive = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction) {
            self.weatherView.searchBar.alpha = self.searchBarButtonTap ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - SearchBar Delegate
extension WeatherViewController: UISearchBarDelegate {
    // Sets the `destinationCityName`property when the searchBar keybord return key is triggered.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchedCity = weatherView.searchBar.text, !searchedCity.isEmpty else {return}
        destinationCityName = searchedCity
        weatherView.searchBar.resignFirstResponder()
        searchBarButtonTapped()
    }
}
