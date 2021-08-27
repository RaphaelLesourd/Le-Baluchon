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

    override func setUp() {
        super.setUp()
        sut = ApiService(session: URLSessionFake(data: nil, response: nil, error: nil))
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testApiService_noUrl_withError() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: nil)
        sut = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getData(with: nil) { (result: Result<CurrencyList, ApiError>) in
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
