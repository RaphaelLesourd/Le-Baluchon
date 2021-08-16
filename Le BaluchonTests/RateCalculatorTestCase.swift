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
// MARK: - Success Calculation

    // Test wih decimal amount
    func testGivenRate_WhenAddingDecimalAmount_thenCalculateConvertedAmount() {
        // Given
        let rate = 118.0
        // When
        sut.amountToConvert = "100,40"
        // Then
        sut.convertAmount(with: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(11847.2, amount)
            case .failure(let error):
                print(error.description)
            }
        }
    }

// Test with no decimal in the amount
    func testGivenRate_WhenAddingAmountNoDecimal_thenCalculateConvertedAmount() {
        // Given
        let rate = 1.18
        // When
        sut.amountToConvert = "100"
        // Then
        sut.convertAmount(with: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(118, amount)
            case .failure(let error):
                print(error.description)
            }
        }
    }
// Test calculation the opposite rate (USD -> EUR to EUR -> USD)
    func testGivenRate_WhenConvertingToOppositeRate_thenCalculateConvertedAmount() {
        // Given
        let rate = 1.18
        // When
        sut.invertRates(for: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(0.8474576271186441, amount)
            case .failure(let error):
                print(error.description)
            }
        }
    }

    // MARK: - Errors
    func testGivenRate_WhenAddingAmountWith2Points_thenCalculateConvertedAmount() {
        // Given
        let rate = 1.18
        // When
        sut.amountToConvert = "100.0.0"
        // Then
        sut.convertAmount(with: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(118, amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.format.description, error.description)
            }
        }
    }

    func testGivenRate_WhenAddingAmountWith2Comas_thenCalculateConvertedAmount() {
        // Given
        let rate = 1.18
        // When
        sut.amountToConvert = "100,0,0"
        // Then
        sut.convertAmount(with: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(118, amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.format.description, error.description)
            }
        }
    }

    // Test when the amount to convert is not numbers
    func testGivenRate_WhenStringAmountIsEmpty_thenCalculateConvertedAmount() {
        // Given
        let rate = 1.18
        // When
        sut.amountToConvert = ""
        // Then
        sut.convertAmount(with: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(0, amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.noAmount.description, error.description)
            }
        }
    }

    func testGivenRate_WhenStringAmountIsNotNumbers_thenCalculateConvertedAmount() {
        // Given
        let rate = 1.18
        // When
        sut.amountToConvert = "azer"
        // Then
        sut.convertAmount(with: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(0, amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.calculation.description, error.description)
            }
        }
    }

    // Test when amount to convert is nil
    func testGivenRate_WhenAmountIsNil_thenCalculateConvertedAmount() {
        // Given
        let rate = 1.18
        // When
        sut.amountToConvert = nil
        // Then
        sut.convertAmount(with: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(0, amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.calculation.description, error.description)
            }
        }
    }

    // Test when rate is null
    func testGivenZeroRate_WhenConvertingToOppositeRate_thenCalculateConvertedAmount() {
        // Given
        let rate = 0.0
        // When
        sut.invertRates(for: rate) { result in
            switch result {
            case .success(let amount):
                XCTAssertEqual(0, amount)
            case .failure(let error):
                XCTAssertEqual(ConversionError.zeroDivision.description, error.description)
            }
        }
    }
}

