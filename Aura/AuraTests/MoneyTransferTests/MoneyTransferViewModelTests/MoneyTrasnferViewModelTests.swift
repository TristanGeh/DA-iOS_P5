//
//  MoneyTrasnferViewModelTests.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 04/03/2024.
//

import XCTest
@testable import Aura

final class MoneyTrasnferViewModelTests: XCTestCase {
    var viewModel: MoneyTransferViewModel!
        var mockMoneyTransferModel: MockMoneyTransferModel!

        override func setUp() {
            super.setUp()
            mockMoneyTransferModel = MockMoneyTransferModel()
            viewModel = MoneyTransferViewModel()
            viewModel.moneyTransferModel = mockMoneyTransferModel
        }

        func testSendMoneyWithInvalidAmount() {
            viewModel.amount = "invalid"
            viewModel.recipient = "test@example.com"
            viewModel.sendMoney()
            XCTAssertEqual(viewModel.transferMessage, "Invalid amount")
        }

        func testSendMoneyWithInvalidRecipient() {
            viewModel.amount = "10"
            viewModel.recipient = "invalid"
            mockMoneyTransferModel.isRecipientValid = false
            viewModel.sendMoney()
            XCTAssertEqual(viewModel.transferMessage, "Please enter recipient and amount.")
        }

        func testSendMoneySuccess() {
            viewModel.amount = "10"
            viewModel.recipient = "test@example.com"
            mockMoneyTransferModel.isRecipientValid = true
            mockMoneyTransferModel.isAmountValid = true
            viewModel.sendMoney()
            XCTAssertEqual(viewModel.transferMessage, "Successfully transferred 10 to test@example.com")
        }

        override func tearDown() {
            viewModel = nil
            mockMoneyTransferModel = nil
            super.tearDown()
        }
}
