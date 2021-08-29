//
//  WeatherTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class WeatherServiceTestCase: XCTestCase {

    var sut: WeatherService!

    override func setUp() {
        super.setUp()
        sut = WeatherService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Errors
    func testWeatherService_withError() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        sut.apiService = ApiService(session: session)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeather(for: "Paris") { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNil(weather)
            case .failure(let error):
                XCTAssertEqual(error, ApiError.dataError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testWeatherService_noData() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeather(for: "Paris") { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNil(weather)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testWeatherService_correctData_responseKO() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                     response: FakeResponseData.responseKO,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeather(for: "Paris") { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNil(weather)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.responseError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testWeatherService_incorrectData_responseOK() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.incorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeather(for: "Paris") { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNil(weather)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.decodingData.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Success
    func testWeatherService_noError_correctData() {
        // Given
        sut.lang = nil
        let session = URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeather(for: "Paris") { result in
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
}
