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
        let timeInMilliseconds: Double = 170000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime, currentTime: timeInMilliseconds)
        XCTAssertEqual(progress, 0.5)

    }

    // Test if current time is before start time
    func testGivenStarTimeAndEndTimeAsInt_WhenCurrentTimeIsBeforeStartTime_ThenCalculateProgress() {
        // When
        let timeInMilliseconds: Double = 150000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime, currentTime: timeInMilliseconds)
        XCTAssertEqual(progress, 0.0)
    }

    // Test is current time is after end time
    func testGivenStarTimeAndEndTimeAsInt_WhenCurrentTimeIsAfterEndTime_ThenCalculateProgress() {
        // When
        let timeInMilliseconds: Double = 190000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime, currentTime: timeInMilliseconds)
        XCTAssertEqual(progress, 1.0)

    }

    // Test convert a timestamp adding time difference to readable time
    func testFormatingIntTimestamp_GivenTimestampAndTimedifferenceInt_ThenDisplayTime() {
        let result = sut.calculateTimeFromTimeStamp(with: 15000, and: -14000)

        guard let formatter: String = DateFormatter.dateFormat(fromTemplate: "j",
                                                               options: 0,
                                                               locale: Locale.current) else {
            return
        }
        if formatter.contains("a") {
            XCTAssertEqual(result, "12:16 AM")
        } else {
            XCTAssertEqual(result, "00:16")
        }
    }
}
