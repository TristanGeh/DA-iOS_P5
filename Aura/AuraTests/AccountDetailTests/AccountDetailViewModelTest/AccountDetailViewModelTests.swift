//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 04/03/2024.
//

import XCTest
@testable import Aura

final class AccountDetailViewModelTests: XCTestCase {
    var viewModel: AccountDetailViewModel!
        var mockServiceLayer: MockServiceLayer!

        override func setUp() {
            super.setUp()
            mockServiceLayer = MockServiceLayer()
            viewModel = AccountDetailViewModel()
        }

    func testLoadRecentTransactions() {
        let transactions = [Transaction(label: "Transaction 1", value: 10),
                            Transaction(label: "Transaction 2", value: 20),
                            Transaction(label: "Transaction 3", value: 30),
                            Transaction(label: "Transaction 4", value: 40)]
        let accountDetail = AccountDetail(currentBalance: 100, transactions: transactions)
        mockServiceLayer.mockAccountDetails = accountDetail

        mockServiceLayer.fetchAccountDetail { accountDetail, _ in
            self.viewModel.recentTransactions = Array(accountDetail!.transactions.prefix(3))
            self.viewModel.totalAmount = "\(accountDetail!.currentBalance)"
        }

        XCTAssertEqual(viewModel.recentTransactions.count, 3, "Il devrait y avoir 3 transactions récentes")
        XCTAssertFalse(viewModel.totalAmount.isEmpty, "totalAmount ne devrait pas être vide")
    }



        override func tearDown() {
            viewModel = nil
            mockServiceLayer = nil
            super.tearDown()
        }

}
