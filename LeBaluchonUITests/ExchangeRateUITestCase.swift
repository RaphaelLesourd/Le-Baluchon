//
//  LeBaluchonUITests.swift
//  LeBaluchonUITests
//
//  Created by Birkyboy on 23/08/2021.
//

import XCTest

class ExchangeRateUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testExchangeTabViews() {
        let tabBar = app.tabBars["Tab Bar"]
        let tauxDeChangeButton = tabBar.buttons["Taux de change"]
        tauxDeChangeButton.tap()
        let scrollView = app.scrollViews.containing(.other, identifier: "Horizontal scroll bar, 1 page").element

        let elementsQuery = app.scrollViews.otherElements
        let title = elementsQuery.staticTexts["Taux de change"]
        let swapCurrencyButton = elementsQuery.buttons["sort"]
        let element = elementsQuery.containing(.button, identifier: "sort").children(matching: .other).element
        let orignCurrencyView = element.children(matching: .other)
            .element(boundBy: 1).children(matching: .other).element(boundBy: 0)
        let destinationCurrencyView = element.children(matching: .other)
            .element(boundBy: 2).children(matching: .other).element(boundBy: 0)
        let rateView = element.children(matching: .other).element(boundBy: 3)
            .children(matching: .other).element(boundBy: 0)

        let footerLabel = elementsQuery.staticTexts["Taux de change par fixer.io\nTirez pour rafraichir"]

        XCTAssertTrue(scrollView.exists)
        XCTAssertTrue(title.exists)
        XCTAssertTrue(swapCurrencyButton.exists)
        XCTAssertEqual(title.label, "Taux de change")
        XCTAssertTrue(orignCurrencyView.exists)
        XCTAssertTrue(destinationCurrencyView.exists)
        XCTAssertTrue(rateView.exists)
        XCTAssertTrue(footerLabel.exists)
        XCTAssertEqual(footerLabel.label, "Taux de change par fixer.io\nTirez pour rafraichir")
    }
}
