//
//  QuoteManagerTests.swift
//  QuotesTests
//
//  Created by Donovan Holmes on 8/20/24.
//

import XCTest
import FirebaseFirestore
@testable import Quotes


final class QuoteManagerTests: XCTestCase {
    var quoteManager: QuoteManager!

    override func setUpWithError() throws {
        quoteManager = QuoteManager.shared
    }

    override func tearDownWithError() throws {
        quoteManager = nil
    }

    func testFetchCategories() throws {
        let expectation = self.expectation(description: "Fetch categories")

        quoteManager.fetchCategories()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(self.quoteManager.categories.isEmpty, "Categories should be fetched and populated")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchQuotes() throws {
        let expectation = self.expectation(description: "Fetch quotes for a category and era")

        quoteManager.fetchQuotes(for: "Music", era: "1990s") { quotes in
            XCTAssertNotNil(quotes, "Quotes should be fetched for the given category and era")
            XCTAssertFalse(quotes.isEmpty, "Quotes should not be empty")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}

