//
//  TranslationServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 17/08/2021.
//

@testable import LeBaluchon
import XCTest

class TranslationServiceTestCase: XCTestCase {

    let translationService = TranslationService()
    // MARK: - Success
    func testTranslationService_ForTranslation_CompletionWithNoErrorAndCorrectData() {
        // Given
        translationService.apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.translationCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))
        // When
        translationService.getTranslation(for: "Bonjour", from: "fr", to: "en") { result in
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

    // MARK: - Error noData
    func testTranslationService_ForTranslation_CompletionWithErrorNoData() {
        // Given
        translationService.apiService = ApiService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: nil))
        // When
        translationService.getTranslation(for: "", from: "fr", to: "en") { result in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertNil(translation)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
        }
    }
}
