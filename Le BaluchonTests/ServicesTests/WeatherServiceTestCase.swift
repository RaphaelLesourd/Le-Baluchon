//
//  WeatherTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class WeatherServiceTestCase: XCTestCase {

    let weatherService = WeatherService()

    // MARK: - Success
    func testWeatherService_ForWeather_CompletionWithNoErrorAndCorrectData() {
        // Given

        weatherService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(for: "Paris") { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNotNil(weather)
                XCTAssertEqual("nuageux", weather.weather?[0].description)
                XCTAssertEqual("04d", weather.weather?[0].icon)
                XCTAssertEqual(53, weather.main?.humidity)
                XCTAssertEqual(20.61, weather.main?.temp)
                XCTAssertEqual(0.45, weather.wind?.speed)
                XCTAssertEqual(203, weather.wind?.deg)
                XCTAssertEqual(75, weather.clouds?.all)
                XCTAssertEqual(10000, weather.visibility)
                XCTAssertEqual(1019, weather.main?.pressure)
                XCTAssertEqual("Paris", weather.name)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Error noData
    func testWeatherService_ForWeather_CompletionWithErrorNoData() {
        // Given
        weatherService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        weatherService.getWeather(for: "Paris") { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNil(weather)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
        }
    }
}
