//
//  MockMoneyTransferModel.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 04/03/2024.
//

import Foundation
@testable import Aura

class MockMoneyTransferModel: MoneyTransferModel {
    var isRecipientValid = true
    var isAmountValid = true

    override func isRecipientValid(recipient: String) -> Bool {
        return isRecipientValid
    }

    override func isAmountValid(amount: Decimal) -> Bool {
        return isAmountValid
    }

    override func moneyTransfer(recipient: String, amount: Decimal) {
        // Simulate money transfer without actual network call
    }
}
