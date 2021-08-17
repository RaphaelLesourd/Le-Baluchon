//
//  ExchangeServiceTestCase.swift
//  Le BaluchonTests
//
//  Created by Birkyboy on 09/08/2021.
//
@testable import LeBaluchon
import XCTest

class ApiServiceTestCase: XCTestCase {

    // MARK: - Error cases
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
                XCTAssertEqual(error.description, ApiError.dataError.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    func testApiServiceCompletionWithIncorrectResponseError() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.CurrenciesListCorrectData,
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


    // MARK: - Currencies List Success
    func testApiServiceForCurrencyListCompletionWithNoErrorAndCorrectData() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.CurrenciesListCorrectData,
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

    // MARK: - Languages List Success
    func testApiServiceForLanguagesListCompletionWithNoErrorAndCorrectData() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.LanguagesListCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: Languages.self, request: request) { result in
            // Then
            switch result {
            case .success(let languages):
                XCTAssertNotNil(languages)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Exchange Rate Success
    func testApiServiceForExchangeRateCompletionWithNoErrorAndCorrectData() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.ExhangeRateCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: Rate.self, request: request) { result in
            // Then

            switch result {
            case .success(let rate):
                XCTAssertNotNil(rate)
                XCTAssertEqual(["LAK":11288.155897], rate.rates)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Translation Rate Success
    func testApiServiceForTranslationCompletionWithNoErrorAndCorrectData() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.TranslationCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: Translation.self, request: request) { result in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertNotNil(translation)
                XCTAssertEqual("Hello", translation.data.translations.first?.translatedText!)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

    // MARK: - Weather Rate Success
    func testApiServiceForWeatherCompletionWithNoErrorAndCorrectData() {
        // Given
        let apiService = ApiService(
            session: URLSessionFake(data: FakeResponseData.WeatherCorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        let url = URL(string: "http://google.com")!
        let request = URLRequest(url: url)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        apiService.getData(for: Weather.self, request: request) { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNotNil(weather)
                XCTAssertEqual("nuageux", weather.weather?[0].description)
                XCTAssertEqual("04d", weather.weather?[0].icon)
                XCTAssertEqual(53, weather.main?.humidity)
                XCTAssertEqual(20.61, weather.main?.temp)
                XCTAssertEqual(0.45, weather.wind?.speed)
                XCTAssertEqual(203, weather.wind?.deg)
                XCTAssertEqual(75, weather.clouds?.all)
                XCTAssertEqual(10000, weather.visibility)
                XCTAssertEqual(1019, weather.main?.pressure)
                XCTAssertEqual("Paris", weather.name)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.10)
    }

}
