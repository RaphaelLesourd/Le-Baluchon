//
//  ExchangeServiceTestCase.swift
//  Le BaluchonTests
//
//  Created by Birkyboy on 09/08/2021.
//
@testable import LeBaluchon
import XCTest

class ApiServiceTestCase: XCTestCase {

    func testApiServiceCompletionWithError() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: ApiError.self as? Error))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: CurrencyList.self, request: request) { result in
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

    func testApiServiceCompletionWithNoDataError() {
        // Given

        let apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: Error.self as? Error))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: CurrencyList.self, request: request) { result in
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

    func testApiServiceCompletionWithIncorrectResponseError() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.MoneySymbolsCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: CurrencyList.self, request: request) { result in
            // Then
            switch result {
            case .success(let currencies):
                XCTAssertNil(currencies)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(500).description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testApiServiceCompletionWithIncorrectDataErrorAndResponseOK() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: CurrencyList.self, request: request) { result in
            // Then
            switch result {
            case .success(let currencies):
                XCTAssertNil(currencies)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.decodingData.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testApiServiceCompletionWithNoResponseError() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: nil,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: CurrencyList.self, request: request) { result in
            // Then
            switch result {
            case .success(let currencies):
                XCTAssertNil(currencies)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.responseError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - All working
    func testApiServiceCompletionWithNoErrorAndCorrectData() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.MoneySymbolsCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: CurrencyList.self, request: request) { result in
            // Then
            switch result {
            case .success(let currencies):
                XCTAssertNotNil(currencies)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

}
