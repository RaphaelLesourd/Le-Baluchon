//
//  TranslationUITestCase.swift
//  LeBaluchonUITests
//
//  Created by Birkyboy on 23/08/2021.
//

import XCTest

class TranslationUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testTranslationTabViews() {

        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Traduction"].tap()

        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let title = elementsQuery.staticTexts["Traduction"]

        let originLanguague = elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Français"]/*[[".buttons[\"Français\"].staticTexts[\"Français\"]",".staticTexts[\"Français\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let destinationLanguage = elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Anglais"]/*[[".buttons[\"Anglais\"].staticTexts[\"Anglais\"]",".staticTexts[\"Anglais\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        let languageSwapButton = elementsQuery.buttons["Arrow Right Circle"]

        let originTextView = elementsQuery.textViews.containing(.staticText, identifier:"Saisissez votre texte").element
        let translatedTextView =  app.scrollViews.containing(.other, identifier:"Horizontal scroll bar, 1 page").children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 3).children(matching: .textView).element
        let footerLabel = elementsQuery.staticTexts["Traduction par Google Translate\nTirez pour rafraichir"]
        let clearTextButton = elementsQuery.buttons["X Circle"]

        XCTAssertTrue(title.exists)
        XCTAssertEqual(title.label, "Traduction")

        XCTAssertTrue(originLanguague.exists)
        XCTAssertTrue(destinationLanguage.exists)
        XCTAssertTrue(languageSwapButton.exists)

        XCTAssertTrue(originTextView.exists)
        XCTAssertTrue(translatedTextView.exists)
        XCTAssertTrue(clearTextButton.exists)
        
        XCTAssertTrue(footerLabel.exists)
        XCTAssertEqual(footerLabel.label, "Traduction par Google Translate\nTirez pour rafraichir")
    }

}
