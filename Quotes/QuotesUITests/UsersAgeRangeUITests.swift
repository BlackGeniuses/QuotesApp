//
//  UsersAgeRangeUITests.swift
//  QuotesUITests
//
//  Created by Donovan Holmes on 8/20/24.

import XCTest

final class UsersAgeRangeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSelectAgeRangeAndSubmit() throws {
        let app = XCUIApplication()
        
        // Ensure the app is launched
        XCTAssertNotNil(app)

        // Tap on an age range
        let ageRange = "25-34"
        let ageRangeButton = app.buttons[ageRange]
        XCTAssertTrue(ageRangeButton.exists, "\(ageRange) button should exist")
        ageRangeButton.tap()

        // Verify that the checkmark appears
        let checkmark = app.images["checkmark"]
        XCTAssertTrue(checkmark.exists, "Checkmark should appear when an age range is selected")

        // Tap the "Continue" button
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists, "Continue button should exist")
        continueButton.tap()

        // Add assertions to verify navigation to the next screen
        let quotePreferenceScreen = app.staticTexts["Quote Preference Screen"] // Replace with an actual identifier for the next screen
        XCTAssertTrue(quotePreferenceScreen.exists, "Quote Preference Screen should be visible")
    }
}
