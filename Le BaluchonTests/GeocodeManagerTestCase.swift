//
//  GeocodeManagerTestCase.swift
//  LeBaluchonTests
//
//  Created by Birkyboy on 22/08/2021.
//
@testable import LeBaluchon
import XCTest
import CoreLocation

class GeocodeManagerTestCase: XCTestCase {

    var sut: GeocodeManager!
    var coordinates = CLLocation(latitude: 48.864716, longitude: 2.349014)

    override func setUp() {
        super.setUp()
        sut = GeocodeManager.shared
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }


    // MARK: - Error
    func testGeocodeManager_whenGivenNilCoodinates_ThenReturnError() {
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getCityName(for: nil) { result in
            // Then
            switch result {
            case .success(let city):
                XCTAssertNil(city)
            case .failure(let error):
                XCTAssertEqual(error.description, GeocodingError.invalidCoordinates.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGeocodeManager_whenGivenBadCoodinates_ThenReturnError() {
        coordinates = CLLocation(latitude: 100000000, longitude: 0)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getCityName(for: coordinates) { result in
            // Then
            switch result {
            case .success(let city):
                XCTAssertNil(city)
            case .failure(let error):
                XCTAssertEqual(error.description, GeocodingError.locationNotFound.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Succes
    func testGeocodeManager_whenGivenCoodinates_ThenReturnCityName() {
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getCityName(for: coordinates) { result in
            // Then
            switch result {
            case .success(let city):
                XCTAssertEqual(city, "Paris")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

}
