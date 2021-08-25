//
//  CurrenciesListUITestCases.swift
//  LeBaluchonUITests
//
//  Created by Birkyboy on 23/08/2021.
//

import XCTest

class CurrenciesListUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testViewsPresent() {
        app.tabBars["Tab Bar"].buttons["Taux de change"].tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["EUR"]/*[[".buttons[\"EUR\"].staticTexts[\"EUR\"]",".staticTexts[\"EUR\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let title = app.staticTexts["Devises"]
        let searchBarTextField = app.searchFields["Recherche"]

        XCTAssertTrue(searchBarTextField.exists)
        XCTAssertTrue(title.exists)

    }
}
