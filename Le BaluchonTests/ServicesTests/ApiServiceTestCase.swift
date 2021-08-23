//
//  ExchangeServiceTestCase.swift
//  Le BaluchonTests
//
//  Created by Birkyboy on 09/08/2021.
//
@testable import LeBaluchon
import XCTest

class ApiServiceTestCase: XCTestCase {

    var sut: ApiService!

    func testApiServiceCompletionWithNoUrl() {
        // Given
        sut = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getData(for: CurrencyList.self, with: nil) { result in
            // Then
            switch result {
            case .success(let currencies):
                XCTAssertNil(currencies)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.urlError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }
}
