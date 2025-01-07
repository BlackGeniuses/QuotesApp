//
//  ReferralSourceScreenUITests.swift
//  QuotesUITests
//
//  Created by Donovan Holmes on 8/20/24.
//
import XCTest

final class ReferralSourceScreenUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReferralSourceSelection() throws {
        let app = XCUIApplication()
        
        // Ensure the app is launched
        XCTAssertNotNil(app)
        
        // Tap on "Social Media" to show detail picker
        let socialMediaButton = app.buttons["Social Media"]
        XCTAssertTrue(socialMediaButton.exists, "Social Media button should exist")
        socialMediaButton.tap()

        // Ensure detail picker is shown
        let picker = app.pickers.element
        XCTAssertTrue(picker.exists, "Picker should be visible after selecting Social Media")
        
        // Select an option from the picker
        let facebookOption = picker.buttons["Facebook"]
        XCTAssertTrue(facebookOption.exists, "Facebook option should be available in the picker")
        facebookOption.tap()

        // Verify that the selected detail is displayed correctly (if applicable)
        // Add additional assertions based on your specific UI behavior

        // Tap the "Continue" button to proceed
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists, "Continue button should exist")
        continueButton.tap()

        // Add assertions to verify navigation to the next screen
        // For example, checking if a new element on the next screen is visible
        // let nextScreenElement = app.staticTexts["Next Screen Element"]
        // XCTAssertTrue(nextScreenElement.exists, "Next screen element should be visible")
    }

    func testReferralSourceOtherTextField() throws {
        let app = XCUIApplication()
        
        // Ensure the app is launched
        XCTAssertNotNil(app)
        
        // Tap on "Other" to show text field
        let otherButton = app.buttons["Other"]
        XCTAssertTrue(otherButton.exists, "Other button should exist")
        otherButton.tap()

        // Ensure text field is shown
        let textField = app.textFields["Please specify"]
        XCTAssertTrue(textField.exists, "Text field should be visible after selecting Other")

        // Enter text into the text field
        textField.tap()
        textField.typeText("Some other source")

        // Tap the "Continue" button to proceed
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists, "Continue button should exist")
        continueButton.tap()

        // Add assertions to verify navigation to the next screen
        // For example, checking if a new element on the next screen is visible
        // let nextScreenElement = app.staticTexts["Next Screen Element"]
        // XCTAssertTrue(nextScreenElement.exists, "Next screen element should be visible")
    }
}
