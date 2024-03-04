//
//  MoneyTransferModelTests.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 04/03/2024.
//

import XCTest
@testable import Aura

class MoneyTransferModelTests: XCTestCase {
    var model: MoneyTransferModel!
    var mockServiceLayer: MockServiceLayer!

    override func setUp() {
        super.setUp()
        model = MoneyTransferModel()
        mockServiceLayer = MockServiceLayer()
    }

    func testIsRecipientValidWithEmail() {
        XCTAssertTrue(model.isRecipientValid(recipient: "test@example.com"))
    }

    func testIsRecipientValidWithPhone() {
        XCTAssertTrue(model.isRecipientValid(recipient: "+33123456789"))
    }

    func testIsRecipientInvalid() {
        XCTAssertFalse(model.isRecipientValid(recipient: "invalid"))
    }

    func testIsAmountValid() {
        XCTAssertTrue(model.isAmountValid(amount: 10))
    }

    func testIsAmountInvalid() {
        XCTAssertFalse(model.isAmountValid(amount: -5))
    }

    override func tearDown() {
        model = nil
        mockServiceLayer = nil
        super.tearDown()
    }
}
