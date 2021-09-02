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
    func testLanguesService_withError() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        sut.apiService = ApiService(session: session)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages { result in
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

    func testLanguagesService_noData() {
        // Given
        let session = URLSessionFake(data: nil, response: nil, error: nil)
        sut.apiService = ApiService(session: session)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages { result in
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

    func testLanguagesService_correctData_responseKO() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.languagesListCorrectData,
                                     response: FakeResponseData.responseKO,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages { result in
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

    func testLanguagesService_incorrectData_responseOK() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.incorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getLanguages { result in
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
    func testLanguagesService_noError_correctData() {
        // Given
        let session = URLSessionFake(data: FakeResponseData.languagesListCorrectData,
                                     response: FakeResponseData.responseOK,
                                     error: nil)
        sut.apiService = ApiService(session: session)
        // When
        sut.getLanguages { result in
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
