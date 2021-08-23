//
//  LnguagesListUITestCase.swift
//  LeBaluchonUITests
//
//  Created by Birkyboy on 23/08/2021.
//

import XCTest

class LanguagesListUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testViewsPresent() {

        app.tabBars["Tab Bar"].buttons["Traduction"].tap()
        app.scrollViews.otherElements.staticTexts["Français"].tap()

        let title = app.staticTexts["Langues"]
        let searchBarTextField = app.searchFields["Recherche"]

        XCTAssertTrue(searchBarTextField.exists)
        XCTAssertTrue(title.exists)
    }
}
