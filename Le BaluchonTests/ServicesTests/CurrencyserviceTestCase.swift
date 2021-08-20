//
//  CurrencyserviceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class CurrencyserviceTestCase: XCTestCase {

    let currencyService = CurrencyService()

    // MARK: - Success
    func testCurrencyService_ForCurrencyList_CompletionWithNoErrorAndCorrectData() {
        // Given
        currencyService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.currenciesListCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        currencyService.getCurrencies() { result in
            // Then
            switch result {
            case .success(let currencyList):
                XCTAssertNotNil(currencyList)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    // MARK: - Error noData
    func testCurrencyService_ForCurrencyList_CompletionWithErrorAndNoData() {
        // Given
        currencyService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        currencyService.getCurrencies() { result in
            // Then
            switch result {
            case .success(let currencyList):
                XCTAssertNil(currencyList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
        }
    }
}
