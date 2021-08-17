//
//  RateServiceTests.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class RateServiceTestCase: XCTestCase {

    // MARK: - Success
    func testApiServiceForExchangeRateCompletionWithNoErrorAndCorrectData() {
        // Given
        let rateService = RateService()
        rateService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.ExhangeRateCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        rateService.getRate(for: "EUR", destinationCurrency: "LAK") { result in
            switch result {
            case .success(let rate):
                XCTAssertNotNil(rate)
                print(rate)
                XCTAssertEqual(["LAK":11288.155897], rate.rates)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Errors
    func testApiServiceForExchangeRateCompletionWithBadRequest() {
        // Given
        let rateService = RateService()
        rateService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        rateService.getRate(for: "", destinationCurrency: "LAK") { result in
            switch result {
            case .success(let rate):
                XCTAssertNil(rate)
                print(rate)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.10)
    }
   
}
