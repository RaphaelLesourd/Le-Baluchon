//
//  FakeResponseData.swift
//  Le BaluchonTests
//
//  Created by Birkyboy on 09/08/2021.
//

import Foundation

class FakeResponseData {

    // MARK: - Data
    static var MoneySymbolsCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "MoneySymbols", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let incorrectData = "error".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(url: URL(string: "http://google.com")!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "http://google.com")!,
                                     statusCode: 500,
                                     httpVersion: nil,
                                     headerFields: nil)!

    // MARK: - Error
    class ResponseError: Error {}
    let error = ResponseError()
}
