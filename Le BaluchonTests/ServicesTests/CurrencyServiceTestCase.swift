//
//  CurrencyserviceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class CurrencyServiceTestCase: XCTestCase {
    
    var sut: CurrencyService!
    
    override func setUp() {
        super.setUp()
        sut = CurrencyService()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Errors
    func testCurrencyService_withError() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        sut.apiService = ApiService(session: session)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getCurrencies() { result in
            // Then
            switch result {
            case .success(let currencyList):
                XCTAssertNil(currencyList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }
    
    func testCurrencyService_noData() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getCurrencies() { result in
            // Then
            switch result {
            case .success(let currencyList):
                XCTAssertNil(currencyList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }
    
    func testCurrencyService_correctData_responseKO() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.currenciesListCorrectData,
                                     response: FakeResponseData.responseKO,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getCurrencies() { result in
            // Then
            switch result {
            case .success(let currencyList):
                XCTAssertNil(currencyList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.responseError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }
    
    func testCurrencyService_incorrectData_responseOK() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.incorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(
            session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getCurrencies() { result in
            // Then
            switch result {
            case .success(let currencyList):
                XCTAssertNil(currencyList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.decodingData.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }
    
    
    // MARK: - Success
    func testCurrencyService_noError_correctData() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.currenciesListCorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(
            session: session)
        // When
        sut.getCurrencies() { result in
            // Then
            switch result {
            case .success(let currencyList):
                XCTAssertNotNil(currencyList)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
