//
//  MoneyTransferModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 12/02/2024.
//

import Foundation
class MoneyTransferModel {
    var serviceLayer = ServiceLayer()
    
    func isRecipientValid(recipient: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let phoneRegex = "^\\+33\\s?\\d{9}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return emailTest.evaluate(with: recipient) || phoneTest.evaluate(with: recipient)
    }
    func isAmountValid(amount: Decimal) -> Bool {
        return amount > 0
    }
    
    func moneyTransfer(recipient: String, amount: Decimal) {
        serviceLayer.sendMoneyTransfer(recipient: recipient, amount: amount)
    }
}
