//
//  WeatherIconServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class WeatherIconServiceTestCase: XCTestCase {

// MARK: - Success
    func testWeatherIconService_ForWeatherIcon_CompletionWithNoErrorAndCorrectData() {
        // Given
       let weatherIconService = WeatherIconService(session: URLSessionFake(data: FakeResponseData.weatherImageCorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { data in
            // Then
            XCTAssertEqual(data, FakeResponseData.weatherImageCorrectData)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.10)
    }

// MARK: - Error noData
    func testWeatherIconService_ForWeatherIcon_CompletionWithNoDataResponseOK() {
        // Given
        let weatherIconService = WeatherIconService(session: URLSessionFake(data: nil,
                                                                            response: FakeResponseData.responseOK,
                                                                            error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { data in
            // Then
            XCTAssertNil(data)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.10)
    }

    func testWeatherIconService_ForWeatherIcon_CompletionWithNoDataNoResponse() {
        // Given
        let weatherIconService = WeatherIconService(session: URLSessionFake(data: nil,
                                                                            response: FakeResponseData.responseKO,
                                                                            error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { data in
            // Then
            XCTAssertNil(data)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.10)
    }

    func testWeatherIconService_ForWeatherIcon_CompletionWithNoData() {
        // Given
        let weatherIconService = WeatherIconService(session: URLSessionFake(data: FakeResponseData.incorrectData,
                                                                            response: nil,
                                                                            error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { data in
            // Then
            XCTAssertNil(data)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.10)
    }

    
}
