//
//  LanguagesServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class LanguagesServiceTestCase: XCTestCase {

    let languagesService = LanguagesService()

    // MARK: - Success
    func testLanguagesService_ForLanguagesList_CompletionWithNoErrorAndCorrectData() {
        // Given
        languagesService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.languagesListCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        languagesService.getLanguages() { result in
            // Then
            switch result {
            case .success(let languagesList):
                XCTAssertNotNil(languagesList)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    // MARK: - Error noData
    func testLanguagesService_ForLanguagesList_CompletionWithErrorAndNoData() {
        // Given
        languagesService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        languagesService.getLanguages() { result in
            // Then
            switch result {
            case .success(let languagesList):
                XCTAssertNil(languagesList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }
}
