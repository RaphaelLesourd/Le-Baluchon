//
//  RateServiceTests.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class RateServiceTestCase: XCTestCase {

    let rateService = RateService()

    // MARK: - Errors

    func testApiServiceCompletionWithError() {
        // Given
        rateService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: ApiError.self as? Error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        rateService.getRate(for: "EUR", destinationCurrency: "LAK") { result in
            // Then
            switch result {
            case .success(let currencies):
                XCTAssertNil(currencies)
            case .failure(let error):
                XCTAssertEqual(error, ApiError.dataError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorNoData() {
        // Given
        rateService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        rateService.getRate(for: "EUR", destinationCurrency: "LAK") { result in
            // Then
            switch result {
            case .success(let rate):
                XCTAssertNil(rate)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorIfIncorrectResponse() {
        // Given
        rateService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.exhangeRateCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        rateService.getRate(for: "EUr", destinationCurrency: "LAK") { result in
            // Then
            switch result {
            case .success(let rate):
                XCTAssertNil(rate)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.responseError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorIfIncorrectData() {
        // Given
        rateService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        rateService.getRate(for: "EUr", destinationCurrency: "LAK") { result in
            // Then
            switch result {
            case .success(let rate):
                XCTAssertNil(rate)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.decodingData.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Success
    func testRateService_ForExchangeRate_CompletionWithNoErrorAndCorrectData() {
        // Given
        rateService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.exhangeRateCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        rateService.getRate(for: "EUR", destinationCurrency: "LAK") { result in
            //Then
            switch result {
            case .success(let rate):
                XCTAssertNotNil(rate)
                XCTAssertEqual(["LAK":11288.155897], rate.rates)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

}
