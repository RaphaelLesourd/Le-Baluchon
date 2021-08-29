//
//  WeatherUITestCase.swift
//  LeBaluchonUITests
//
//  Created by Birkyboy on 23/08/2021.
//

import XCTest

class WeatherUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testViewsPresent() {

        app.tabBars["Tab Bar"].buttons["Météo"].tap()

        let elementsQuery = app.scrollViews.otherElements
        let title = elementsQuery.staticTexts["Météo"]

        let searchButton = elementsQuery.buttons["Search"]
        let searchBar = elementsQuery.searchFields["Recherchez"]

        XCTAssertTrue(title.exists)
        XCTAssertEqual(title.label, "Météo")

        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        XCTAssertTrue(searchBar.exists)
    }

    func testExtendedWeatherViewPresent() {
        app.tabBars["Tab Bar"].buttons["Météo"].tap()
        let elementsQuery = app.scrollViews
        let element = elementsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element.swipeUp()

        let destinationWeatherIcon = element.children(matching: .other)
            .element(boundBy: 2).children(matching: .other).element

        let directionView = elementsQuery.staticTexts["Direction"]
        let windView = elementsQuery.staticTexts["Vent"]
        let visiblityView = elementsQuery.staticTexts["Visibilité"]
        let humidityView = elementsQuery.staticTexts["Humidité"]
        let pressureView = elementsQuery.staticTexts["Préssion"]
        let cloudView = elementsQuery.staticTexts["Nuages"]

        XCTAssertTrue(destinationWeatherIcon.exists)
        XCTAssertTrue(directionView.exists)
        XCTAssertTrue(windView.exists)
        XCTAssertTrue(visiblityView.exists)
        XCTAssertTrue(humidityView.exists)
        XCTAssertTrue(pressureView.exists)
        XCTAssertTrue(cloudView.exists)
    }
}
