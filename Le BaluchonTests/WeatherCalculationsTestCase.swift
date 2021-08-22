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
        XCTAssertEqual(progress, 0.5)

    }

    // Test if current time is before start time
    func testGivenStarTimeAndEndTimeAsInt_WhenCurrentTimeIsBeforeStartTime_ThenCalculateProgress() {
        // When
        sut.currentTime = 150000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime)
        XCTAssertEqual(progress, 0)
    }

    // Test is current time is after end time
    func testGivenStarTimeAndEndTimeAsInt_WhenCurrentTimeIsAfterEndTime_ThenCalculateProgress() {
        // When
        sut.currentTime = 190000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: endTime)
        XCTAssertEqual(progress, 1.0)

    }

    // Test convert visibility value from Int to string with speed unit
    func testFormatingIntValueToFormatedVisibiltyAsString() {
        let formatedValue = sut.convertToKilometerString(10000)
        XCTAssertEqual(formatedValue, "10km")
    }

    // Test convert winspeed value from Double to string with speed unit
    func testFormatingDoubleValueToFormatedWindSpeedAsString() {
        let formatedValue = sut.convertToKmPerHourString(10)
        XCTAssertEqual(formatedValue, "36km/h")
    }

    // Test convert a timestamp adding time difference to readable time
    func testFormatingIntTimestamp_GivenTimestampAndTimedifferenceInt_ThenDisplayTime() {
        let result = sut.calculateTimeFromTimeStamp(with: 15000, and: -14000)
        XCTAssertEqual(result, "00:16")
    }

    // MARK: - Errors

    //Test when start time is nil then set progress to 0
    func testGivenStarTimeAndEndTimeAsInt_WhenStarTimeIsNil_ThenSetProgressToZero() {
        // When
        sut.currentTime = 150000
        // Then
        let progress = sut.calculateSunProgress(with: nil, and: endTime)
        XCTAssertEqual(progress, 0)
    }

    //Test when end time is nil then set progress to 0
    func testGivenStarTimeAndEndTimeAsInt_WhenEndTimeIsNil_ThenSetProgressToZero() {
        // When
        sut.currentTime = 150000
        // Then
        let progress = sut.calculateSunProgress(with: startTime, and: nil)
        XCTAssertEqual(progress, 0)
    }


    // Test convert visibility value from Int to string with speed unit
    func testFormatingIntValue_WhenValueIsNil_ThenDisplayNoValuePlaceHolder() {
        let formatedValue = sut.convertToKilometerString(nil)
        XCTAssertEqual(formatedValue, "--")
    }

    // Test convert winspeed value from Double to string with speed unit
    func testFormatingDoubleValue_WhenValueIsNil_ThenDisplayNoValuePlaceHolder() {
        let formatedValue = sut.convertToKmPerHourString(nil)
        XCTAssertEqual(formatedValue, "--")
    }

    // Test convert sun times Int value to date string
    func testFormatingIntTimestamp_WhenTimeStampValueIsNil_ThenDisplayNoValuePlaceHolder() {
        let result = sut.calculateTimeFromTimeStamp(with: nil, and: -14000)
        XCTAssertEqual(result, "--")
    }

    // Test convert sun times Int value to date string
    func testFormatingIntTimestamp_WhenTimeDiffrenceValueIsNil_ThenDisplayNoValuePlaceHolder() {
        let result = sut.calculateTimeFromTimeStamp(with: 15000, and: nil)
        XCTAssertEqual(result, "--")
    }
}
