//
//  CategoryTitleViewTests.swift
//  QuotesUITests
//
//  Created by Donovan Holmes on 8/20/24.

import XCTest
import SwiftUI
@testable import Quotes

final class CategoryTitleViewTests: XCTestCase {

    func testCategoryTitleViewDisplaysQuotes() throws {
        // Given
        let quotes = ["Don't check me check the...": "Larry June"]
        let view = CategoryTitleView(categoryName: "Music", eraName: "1990s", quotes: quotes)

        // When
        let list = try view.inspect().find(ViewType.List.self)
        let row = try list.hStack(0).text(0).string()

        // Then
        XCTAssertEqual(row, "Larry June", "The list should display the correct owner.")
    }

    func testNavigationToQuoteScreen() throws {
        // Given
        let quotes = ["Don't check me check the...": "Larry June"]
        let view = CategoryTitleView(categoryName: "Music", eraName: "1990s", quotes: quotes)

        // When
        let list = try view.inspect().find(ViewType.List.self)
        let link = try list.hStack(0).navigationLink(0)

        // Then
        XCTAssertEqual(try link.destination().text().string(), "Larry June", "Tapping on an owner should navigate to the correct QuoteScreen.")
    }

    func testBackgroundChange() throws {
        // Given
        let viewDayTime = CategoryTitleView(categoryName: "Music", eraName: "1990s", quotes: ["Test": "Owner"])
        let viewNightTime = CategoryTitleView(categoryName: "Music", eraName: "1990s", quotes: ["Test": "Owner"])
        viewDayTime.isDayTime = true
        viewNightTime.isDayTime = false

        // When
        let dayBackground = try viewDayTime.inspect().find(ViewType.ZStack.self)
        let nightBackground = try viewNightTime.inspect().find(ViewType.ZStack.self)

        // Then
        XCTAssertNotEqual(dayBackground, nightBackground, "The background should change based on the isDayTime state.")
    }
}

