//
//  WeatherIconServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class WeatherIconServiceTestCase: XCTestCase {


    // MARK: - Errors
    func testApiServiceCompletionWithError() {
        // Given
        let weatherIconService = WeatherIconService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: ApiError.self as? Error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertEqual(error, ApiError.dataError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorNoData() {
        // Given
        let weatherIconService = WeatherIconService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorIfIncorrectResponse() {
        // Given
        let weatherIconService = WeatherIconService(
            session: URLSessionFake(data: FakeResponseData.weatherImageCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.responseError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorIfIncorrectData() {
        // Given
        let weatherIconService = WeatherIconService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.requestWeatherIcon(with: nil) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.urlError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }


// MARK: - Success
    func testWeatherIconService_ForWeatherIcon_CompletionWithNoErrorAndCorrectData() {
        // Given
        let weatherIconService = WeatherIconService(session: URLSessionFake(data: FakeResponseData.weatherImageCorrectData, response: FakeResponseData.responseOK, error: ApiError.self as? Error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherIconService.getWeatherIcon(for: "04d") { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, FakeResponseData.weatherImageCorrectData)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }
}
