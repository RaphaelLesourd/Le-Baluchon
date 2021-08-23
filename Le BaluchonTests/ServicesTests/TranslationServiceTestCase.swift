//
//  TranslationServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//

@testable import LeBaluchon
import XCTest

class TranslationServiceTestCase: XCTestCase {

    var sut: TranslationService!

    override func setUp() {
        super.setUp()
        sut = TranslationService()
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
        sut.getTranslation(for: "Bonjour", from: "fr", to: "en") { result in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertNil(translation)
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
        sut.getTranslation(for: "Bonjour", from: "fr", to: "en") { result in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertNil(translation)
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
            session: URLSessionFake(data: FakeResponseData.translationCorrectData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getTranslation(for: "Bonjour", from: "fr", to: "en") { result in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertNil(translation)
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
        sut.getTranslation(for: "Bonjour", from: "fr", to: "en") { result in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertNil(translation)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.decodingData.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Success
    func testTranslationService_ForTranslation_CompletionWithNoErrorAndCorrectData() {
        // Given
        sut.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.translationCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        sut.getTranslation(for: "Bonjour", from: "fr", to: "en") { result in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertNotNil(translation)
                XCTAssertEqual("Hello", translation.data.translations[0].translatedText)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
