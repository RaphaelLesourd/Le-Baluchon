//
//  WeatherIconServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class WeatherIconServiceTestCase: XCTestCase {
    
    var sut: WeatherIconService!
    
    override func setUp() {
        super.setUp()
        sut = WeatherIconService(session: URLSessionFake(data: nil, response: nil, error: nil))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    // MARK: - Errors
    func testWeatherIconService_withError() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        sut = WeatherIconService(session: session)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeatherIcon(for: "04d") { result in
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
    
    func testWeatherIconService_noData() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: nil)
        sut = WeatherIconService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeatherIcon(for: "04d") { result in
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
    
    func testWeatherIconService_correctData_responseKO() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.weatherImageCorrectData,
                                     response: FakeResponseData.responseKO,
                                     error: nil)
        sut = WeatherIconService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeatherIcon(for: "04d") { result in
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
    
    func testWeatherIconService_incorrectData_responseOK() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.incorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut = WeatherIconService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.requestWeatherIcon(with: nil) { result in
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
    func testWeatherIconService_noError_correctData() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.weatherImageCorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: ApiError.self as? Error)
        sut = WeatherIconService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getWeatherIcon(for: "04d") { result in
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
