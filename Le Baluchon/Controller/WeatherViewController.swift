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
    private let defaultUserCityName = "Bangkok"
    private let defaultDestinationCityName = "New york"
    private var searchBarButtonTap = true

    /// Property containing the user's current city name
    private var userCityName: String?  {
        didSet{
            getLocalWeatherData()
        }
    }
    /// Prpoerty containing destination city name
    private var destinationCityName: String? {
        didSet{
            getLocalWeatherData()
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
    /// Adds a refreshed to the scrollView, trigger a nework call to fetch latest exchange rate.
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
    /// - Note: If destinationCityName is nil, a default city name is used to request weather data.
    private func getLocalWeatherData() {
        getWeather(for: userCityName ?? defaultUserCityName) { [weak self] weather in
            guard let self = self else {return}
            self.updateLocalWeatherView(with: weather)
            self.getDestinationWeather()
        }
    }
    /// Fetch Weather data for destination city
    /// - Note: If destinationCityName is nil, a default city name is used to request weather data.
    private func getDestinationWeather() {
        self.getWeather(for: self.destinationCityName ?? self.defaultDestinationCityName) { [weak self] weather in
            guard let self = self else {return}
            self.updateDestinationWeatherView(with: weather)
            self.updateDestinationExtendedWeatherView(with: weather)
            self.updateSuntimesView(with: weather)
            self.getWeatherConditionsIcon(with: weather)
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
    /// Fetch weather condition icon in a seperate API call then update the view.
    /// - Note: If an error is trigger, instead of informing the user that there was an error to get this small comonents, it just remains blank.
    /// The error is just printed.
    /// - Parameter weather: Weather object
    private func getWeatherConditionsIcon(with weather: Weather) {
        guard let weatherIcon = weather.weather?[0].icon else {return}
        WeatherIconService.shared.getWeatherIcon(for: weatherIcon) {  [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let iconData):
                self.updateConditionIcon(with: iconData)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    /// Show/start or hide/stop activity control
    /// - Parameter status: Bool to set if activity control should be displayed or not
    private func displayRefresherActivityControls(_ status: Bool) {
        toggleActiviyIndicator(for: weatherView.headerView.activityIndicator,
                               and: weatherView.refresherControl,
                               showing: status)
    }

    // MARK: - User Location
    /// Get user's location returned from location manager.
    /// - Note: If no location is returned the default cityname is used to fetch Weather data.
    @objc private func getUserLocation() {
        guard let currentLocation = locationService.locationManager.location else {
            userCityName = defaultUserCityName
            return
        }
        getUserLocationCityName(for: currentLocation)
    }
    /// Get the city name from user location gps coordinates.
    /// - Parameter userLocation: CLLocattion coordinates
    private func getUserLocationCityName(for userLocation: CLLocation) {
        GeocodeManager.shared.getCityName(for: userLocation) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let cityName):
                self.userCityName = cityName
            case .failure(let error):
                self.presentErrorAlert(with: error.description)
                self.displayRefresherActivityControls(false)
            }
        }
    }

    // MARK: - Search Bar
    @objc private func searchBarButtonTapped() {
        let heightState: SearchBarHeight = searchBarButtonTap ? .expanded : .collapsed
        animateSearchBar(for: heightState)
        searchBarButtonTap.toggle()
        weatherView.searchBar.text = nil
    }
    /// Animate searchBar to be visible or not.
    /// - Parameter height: SearchBarHeight expanded or collapsed case
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
            localWeather.temperatureLabel.text = "\(Int(temperature))°"
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
            destinationWeather.temperatureLabel.text = "\(Int(temperature))°"
        }
        if let weatherCondition = weather.weather?[0].description {
            destinationWeather.conditionsLabel.text = "\(weatherCondition)".capitalized
        }
        if let weatherIcon = weather.weather?[0].icon {
            destinationWeather.weatherIcon.image = UIImage(named: weatherIcon)
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
    private func updateDestinationExtendedWeatherView(with weather: Weather) {
        let weatherInfo = weatherView.destinationExtendedWeatherView
        if let windDirection = weather.wind?.deg {
            weatherInfo.directionView.valueLabel.text = "\(windDirection)°"
        }
        if let windSpeed = weather.wind?.speed {
            weatherInfo.windView.valueLabel.text = windSpeed.formatWithUnit(in: UnitSpeed.kilometersPerHour)
        }
        if let visibility = weather.visibility {
            let visibilityInKm = Double(visibility / 1000)
            weatherInfo.visiblityView.valueLabel.text = visibilityInKm.formatWithUnit(in: UnitLength.kilometers)
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

    /// Update destination weather conditions icon provided by Openweathermap
    /// - Parameter iconData: Image data
    private func updateConditionIcon(with iconData: Data) {
        self.weatherView.destinationWeatherView.conditionsIcon.image = UIImage(data: iconData)
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

    /// Present an error if LocationManager return an error. 
    /// - Parameter error: error message
    func presentError(with error: String) {
        presentErrorAlert(with: error.description)
        displayRefresherActivityControls(false)
    }
}
