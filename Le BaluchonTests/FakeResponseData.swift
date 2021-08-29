//
//  FakeResponseData.swift
//  Le BaluchonTests
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation

class FakeResponseData {

    // MARK: - Data
    static var currenciesListCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CurrenciesList", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var languagesListCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "LanguagesList", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var exhangeRateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Rate", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var translationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var weatherImageCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "04d", withExtension: "png")!
        return try? Data(contentsOf: url)
    }

    static let incorrectData = "error".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://google.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://google.com")!,
                                     statusCode: 500,
                                     httpVersion: nil,
                                     headerFields: nil)!

    class ApiError: Error {}
    static let error = ApiError()
}
