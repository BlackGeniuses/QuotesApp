//
//  UserAccountModelTests.swift
//  QuotesTests
//
//  Created by Donovan Holmes on 8/20/24.
//

import XCTest
import FirebaseFirestore
@testable import Quotes

final class UserAccountModelTests: XCTestCase {
    var userAccountModel: UserAccountModel!

    override func setUpWithError() throws {
        userAccountModel = UserAccountModel(uid: "testUID")
    }

    override func tearDownWithError() throws {
        userAccountModel = nil
    }

    func testLoadOrCreateUserData() throws {
        let expectation = self.expectation(description: "Load or create user data")

        userAccountModel.loadOrCreateUserData { success in
            XCTAssertTrue(success, "User data should load or create successfully")
            XCTAssertNotNil(self.userAccountModel.documentId, "Document ID should not be nil after loading or creating user data")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSaveReferralSource() throws {
        let expectation = self.expectation(description: "Save referral source")

        userAccountModel.saveReferralSource("Friend") { success in
            XCTAssertTrue(success, "Referral source should save successfully")
            XCTAssertTrue(self.userAccountModel.hasCompletedReferral, "Referral should be marked as completed")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSaveAgeRange() throws {
        let expectation = self.expectation(description: "Save age range")

        userAccountModel.saveAgeRange("25-34") { success in
            XCTAssertTrue(success, "Age range should save successfully")
            XCTAssertEqual(self.userAccountModel.ageRange, "25-34", "Age range should be updated")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}

