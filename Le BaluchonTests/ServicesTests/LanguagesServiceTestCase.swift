//
//  LanguagesServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//
@testable import LeBaluchon
import XCTest

class LanguagesServiceTestCase: XCTestCase {

    var sut: LanguagesService!

    override func setUp() {
        super.setUp()
        sut = LanguagesService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    // MARK: - Errors
    func testApiServiceCompletionWithError() {
        // Given
        sut.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: ApiError.self as? Error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages() { result in
            // Then
            switch result {
            case .success(let languagesList):
                XCTAssertNil(languagesList)
            case .failure(let error):
                XCTAssertEqual(error, ApiError.dataError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorNoData() {
        // Given
        sut.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages() { result in
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

    func testRateService_ForExchangeRate_CompletionWithErrorIfIncorrectResponse() {
        // Given
        sut.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.languagesListCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages() { result in
            // Then
            switch result {
            case .success(let languagesList):
                XCTAssertNil(languagesList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.responseError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testRateService_ForExchangeRate_CompletionWithErrorIfIncorrectData() {
        // Given
        sut.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages() { result in
            // Then
            switch result {
            case .success(let languagesList):
                XCTAssertNil(languagesList)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.decodingData.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }


    // MARK: - Success
    func testLanguagesService_ForLanguagesList_CompletionWithNoErrorAndCorrectData() {
        // Given
        sut.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.languagesListCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        sut.getLanguages() { result in
            // Then
            switch result {
            case .success(let languagesList):
                XCTAssertNotNil(languagesList)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
