//
//  RateCalculatorTestCase.swift
//  Le BaluchonTests
//
//  Created by Birkyboy on 14/08/2021.
//

@testable import LeBaluchon
import XCTest

class RateCalculatorTestCase: XCTestCase {

    var sut: RateCalculator!

    override func setUp() {
        super.setUp()
        sut = RateCalculator()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Errors
    func testGivenRate_WhenAddingAmountWith2Points_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.amountToConvert = "100.0.0"
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertNil(amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.format.description, error.description)
            }
        }
    }

    func testGivenRate_WhenAddingAmountWith2Comas_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.amountToConvert = "100,0,0"
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertNil(amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.format.description, error.description)
            }
        }
    }

    // Test when amount to convert is nil
    func testGivenRate_WhenAmountIsNil_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.amountToConvert = nil
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertNil(amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.calculation.description, error.description)
            }
        }
    }

    // Test when amount to convert is nil
    func testGivenRate_WhenAmountCantBecomeADouble_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.amountToConvert = "1,a"
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertNil(amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.calculation.description, error.description)
            }
        }
    }

    // Test when amount to convert is nil
    func testGivenRateIsNil_thenGiveError() {
        // Given
        sut.currentRate = nil
        // When
        sut.amountToConvert = "100"
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertNil(amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.noData.description, error.description)
            }
        }
    }

    // Test calculation the opposite rate (USD -> EUR to EUR -> USD) and initial is nil
    func testGivenRateIsNil_WhenConvertingToOppositeRate_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = nil
        // When
        sut.invertRates()
        // Then
        XCTAssertNil(sut.currentRate)
    }

    // MARK: - Success

    // Test wih decimal amount
    func testGivenRate_WhenAddingDecimalAmount_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.amountToConvert = "100,40"
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(118.472, amount)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    // Test with no decimal in the amount
    func testGivenRate_WhenAddingAmountNoDecimal_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.amountToConvert = "100"
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(118, amount)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    // Test when there is no amount
    func testGivenRate_WhenStringAmountIsEmpty_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.amountToConvert = ""
        // Then
        sut.convertAmount() { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(amount, 0)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    // Test calculation the opposite rate (USD -> EUR to EUR -> USD)
    func testGivenRate_WhenConvertingToOppositeRate_thenCalculateConvertedAmount() {
        // Given
        sut.currentRate = 1.18
        // When
        sut.invertRates()
        // Then
        XCTAssertEqual(0.8474576271186441, sut.currentRate)
    }
}

