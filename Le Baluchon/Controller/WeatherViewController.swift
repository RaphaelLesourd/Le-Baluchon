//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    // MARK: - Properties
    private let weatherView = WeatherMainView()
    private let weatherService = WeatherService()
    private let locationService = LocationService()
    private let weatherCalculations = WeatherCalculations()
    private let defaultUserLocationCity = "Bangkok"
    private let defaultDestinationCity = "New york"
    private var searchBarButtonTap = true

    private var localWeather: Weather? {
        didSet {
            if let localWeather = localWeather {
                updateLocalWeatherView(with: localWeather)
            }
        }
    }
    private var destinationWeather: Weather? {
        didSet {
            if let destinationWeather = destinationWeather {
                updateDestinationWeatherView(with: destinationWeather)
                updateDestinationWeatherInfoView(with: destinationWeather)
                updateSuntimesView(with: destinationWeather)
            }
        }
    }
    private var userLocationCity: String?  {
        didSet{
            getWeatherData()
        }
    }
    private var destinationCityName: String? {
        didSet{
            getWeatherData()
        }
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = weatherView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        addKeyboardDismissGesture()
        setSearchBarButtonTarget()
        setRefresherControl()
        getUserLocation()
    }

    // MARK: - Setup
    private func delegates() {
        weatherView.searchBar.delegate = self
        locationService.delegate = self
    }
    /// Adds a refreshed to the scrollView, trigger a neworl call to fetch latest exchange rate.
    private func setRefresherControl() {
        weatherView.scrollView.refreshControl = weatherView.refresherControl
        weatherView.refresherControl
            .addTarget(self, action: #selector(getUserLocation), for: .valueChanged)
    }

    private func setSearchBarButtonTarget() {
        weatherView.destinationWeatherView.searchButton
            .addTarget(self, action: #selector(searchBarButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Fetch Data
    /// Fetch Weather data for userLocation city and destination city
    private func getWeatherData() {
        getWeather(for: userLocationCity ?? defaultUserLocationCity) { [weak self] weather in
            guard let self = self else {return}
            self.localWeather = weather
            
            self.getWeather(for: self.destinationCityName ?? self.defaultDestinationCity) { [weak self] weather in
                self?.destinationWeather = weather
            }
        }
    }
    /// Get weather data from API.
    /// - Parameters:
    ///   - city: city name.
    ///   - completion: Weather object
    private func getWeather(for city: String, completion: @escaping (Weather) -> Void) {

        displayRefresherActivityControls(true)
        weatherService.getWeather(for: city) { [weak self] result in
            guard let self = self else {return}
            self.displayRefresherActivityControls(false)
            switch result {
            case .success(let weather):
                completion(weather)
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
            }
        }
    }
    private func displayRefresherActivityControls(_ status: Bool) {
        toggleActiviyIndicator(for: weatherView.headerView.activityIndicator,
                               and: weatherView.refresherControl,
                               shown: status)
    }

    // MARK: - User Location

    @objc private func getUserLocation() {
        guard let currentLocation = locationService.locationManager.location else {
            userLocationCity = defaultUserLocationCity
            return
        }
        getUserLocationCityName(for: currentLocation)
    }

    private func getUserLocationCityName(for userLocation: CLLocation) {
        GeocodeManager.shared.getCityName(for: userLocation) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let cityName):
                self.userLocationCity = cityName
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
                self.displayRefresherActivityControls(false)
            }
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

// MARK: - Update view extension
extension WeatherViewController {
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
            localWeather.weatherIcon.image = UIImage(named: weatherIcon)
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
            destinationWeather.weatherIcon.image = UIImage(named: weatherIcon)
            updateWeatherConditionsIcon(with: weatherIcon)
        }
    }

    // Destination sun times
    private func updateSuntimesView(with weather: Weather) {
        guard let sunrise = weather.sys?.sunrise else {return}
        guard let sunset = weather.sys?.sunset else {return}
        guard let timeDifference = weather.timezone else {return}

        let sunriseTime = weatherCalculations.calculateTimeFromTimeStamp(with: sunrise, and: timeDifference)
        weatherView.sunTimesView.sunRiseView.titleLabel.text = sunriseTime

        let sunsetTime = weatherCalculations.calculateTimeFromTimeStamp(with: sunset, and: timeDifference)
        weatherView.sunTimesView.sunSetView.titleLabel.text = sunsetTime

        let progress = weatherCalculations.calculateSunProgress(with: sunrise, and: sunset)
        weatherView.sunTimesView.sunProgressView.progress = progress
        weatherView.sunTimesView.sunProgressView.alpha = progress > 0 && progress < 1 ? 1 : 0
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
            weatherInfo.windView.valueLabel.text = weatherCalculations.convertToKmPerHourString(windSpeed)
        }
        if let visibility = weather.visibility {
            weatherInfo.visiblityView.valueLabel.text = weatherCalculations.convertToKilometerString(visibility)
        }
        if let cloudCoverage = weather.clouds?.all {
            weatherInfo.cloudView.valueLabel.text = "\(cloudCoverage)%"
        }
        if let pressure = weather.main?.pressure {
            weatherInfo.pressureView.valueLabel.text = "\(pressure) hpa"
        }
        if let humidity = weather.main?.humidity {
            weatherInfo.humidityView.valueLabel.text = "\(humidity)%"
        }
    }

    private func updateWeatherConditionsIcon(with iconName: String) {
        WeatherIconService.shared.getWeatherIcon(for: iconName) {  [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let iconData):
                self.weatherView.destinationWeatherView.conditionsIcon.image = UIImage(data: iconData)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

// MARK: - SearchBar Delegate
extension WeatherViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchedCity = weatherView.searchBar.text, !searchedCity.isEmpty else {return}
        destinationCityName = searchedCity
        weatherView.searchBar.resignFirstResponder()
        searchBarButtonTapped()
    }
}

// MARK: - Location Manager Delegate
extension WeatherViewController: LocationServiceDelegate {

    func presentError(with error: String) {
        presentErrorAlert(with: "Nous n'avons pas pu déterminer votre position.")
        displayRefresherActivityControls(false)
    }
}
