//
//  WeatherCalculatorTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 20/08/2021.
//
@testable import LeBaluchon
import XCTest

class WeatherCalculationsTestCase: XCTestCase {

    var sut: WeatherCalculations!
    let startTime = 160000
    let endTime = 180000

    override func setUp() {
        super.setUp()
        sut = WeatherCalculations()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // Test if current time between start and end time
    func testGivenStarTimeAndEndTimeAsInt_WhenCurrentTimeIsBetweenStartEndTime_ThenCalculateProgress() {
        // When
        sut.currentTime = 170000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime)
        print(progress)
        XCTAssertEqual(progress, 0.5)

    }

    // Test if current time is before start time
    func testGivenStarTimeAndEndTimeAsInt_WhenCurrentTimeIsBeforeStartTime_ThenCalculateProgress() {
        // When
        sut.currentTime = 150000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime)
        print(progress)
        XCTAssertEqual(progress, 1.0)
    }

    // Test is current time is after end time
    func testGivenStarTimeAndEndTimeAsInt_WhenCurrentTimeIsAfterEndTime_ThenCalculateProgress() {
        // When
        sut.currentTime = 190000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime)
        print(progress)
        XCTAssertEqual(progress, 1.0)

    }
}
