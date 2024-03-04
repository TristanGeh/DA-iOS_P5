//
//  AuraServiceLayerTests.swift
//  Aura
//
//  Created by Tristan Géhanne on 27/02/2024.
//

import XCTest
@testable import Aura

class ServiceLayerTests: XCTestCase {
    var mockServiceLayer: MockServiceLayer!
    
    override func setUp() {
        super.setUp()
        mockServiceLayer = MockServiceLayer()
    }
    
    func testFetchAuthToken() {
        let expectedToken = "testToken"
        mockServiceLayer.mockAuthToken = expectedToken
        
        mockServiceLayer.fetchAuthToken(username: "test", password: "password") { success in
            XCTAssertEqual(self.mockServiceLayer.mockAuthToken, expectedToken)
        }
    }
    
    func testFetchAuthTokenFailure() {
        mockServiceLayer.mockAuthToken = nil
        
        mockServiceLayer.fetchAuthToken(username: "test", password: "password") { success in
            XCTAssertFalse(success)
        }
    }


    func testFetchAccountDetail() {
        let mockTransactions = [Transaction(label: "Test", value: Decimal(100))]
        let mockAccountDetails = AccountDetail(currentBalance: Decimal(1000), transactions: mockTransactions)
        mockServiceLayer.mockAccountDetails = mockAccountDetails

        mockServiceLayer.fetchAccountDetail { accountDetail, error in
            XCTAssertNotNil(accountDetail)
            XCTAssertEqual(accountDetail?.currentBalance, Decimal(1000))
            XCTAssertEqual(accountDetail?.transactions.count, 1)
        }
    }
    
    func testFetchAccountDetailFailure() {
        let testError = NSError(domain: "com.test.error", code: 1, userInfo: nil)
        mockServiceLayer.error = testError

        mockServiceLayer.fetchAccountDetail { accountDetail, error in
            XCTAssertNil(accountDetail)
            XCTAssertNotNil(error)
        }
    }



    
    func testSendMoneyTransfer() {
        mockServiceLayer.sendMoneySuccess = true
        mockServiceLayer.simulatedHttpStatusCode = 200
        
        mockServiceLayer.sendMoneyTransfer(recipient: "test@example.com", amount: Decimal(100)) { success, error in
            XCTAssertTrue(success, "Transfer d'argent réussie avec un code 200 en réponse")
        }
    }
    
    func testSendMoneyTransferFailure() {
        mockServiceLayer.sendMoneySuccess = false
        mockServiceLayer.simulatedHttpStatusCode = 400

        mockServiceLayer.sendMoneyTransfer(recipient: "test@example.com", amount: Decimal(100)) { success, error in
            XCTAssertFalse(success, "Le transfert d'argent devrait échouer avec un code d'erreur")
        }
    }

}
