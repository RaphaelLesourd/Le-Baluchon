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
    
    // MARK: - Success
    func testRateService_ForExchangeRate_CompletionWithNoErrorAndCorrectData() {
        // Given
        rateService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.exhangeRateCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        rateService.getRate(for: "EUR", destinationCurrency: "LAK") { result in
            //Then
            switch result {
            case .success(let rate):
                XCTAssertNotNil(rate)
                XCTAssertEqual(["LAK":11288.155897], rate.rates)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    // MARK: - Error noData
    func testRateService_ForExchangeRate_CompletionWithErrorNoData() {
        // Given
        rateService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        rateService.getRate(for: "", destinationCurrency: "LAK") { result in
            // Then
            switch result {
            case .success(let rate):
                XCTAssertNil(rate)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
        }
    }
}
