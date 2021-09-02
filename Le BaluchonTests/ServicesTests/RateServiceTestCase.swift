//
//  RateServiceTests.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class RateServiceTestCase: XCTestCase {

    var sut: RateService!

    override func setUp() {
        super.setUp()
        sut = RateService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Errors
    func testRateService_withError() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        sut.apiService = ApiService(session: session)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRate(for: "EUR", destinationCurrency: "LAK") { result in
            // Then
            switch result {
            case .success(let currencies):
                XCTAssertNil(currencies)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_noData() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRate(for: "EUR", destinationCurrency: "LAK") { result in
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

    func testRateService_correctData_responseKO() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.exhangeRateCorrectData,
                                     response: FakeResponseData.responseKO,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRate(for: "EUR", destinationCurrency: "LAK") { result in
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

    func testRateService_incorrectData_responseOK() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.incorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRate(for: "EUr", destinationCurrency: "LAK") { result in
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
    func testRateService_noError_correctData() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.exhangeRateCorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRate(for: "EUR", destinationCurrency: "LAK") { result in
            // Then
            switch result {
            case .success(let rate):
                XCTAssertNotNil(rate)
                XCTAssertEqual(["LAK": 11288.155897], rate.rates)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

}
