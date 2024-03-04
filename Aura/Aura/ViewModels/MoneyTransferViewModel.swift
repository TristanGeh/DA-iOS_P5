//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    
    var moneyTransferModel = MoneyTransferModel()
    
    func sendMoney() {
        guard let amountDecimal = Decimal(string: amount)else {
            transferMessage = "Invalid amount"
            return
        }
        
        if moneyTransferModel.isAmountValid(amount: amountDecimal) && moneyTransferModel.isRecipientValid(recipient: recipient) {
            moneyTransferModel.moneyTransfer(recipient: recipient, amount: amountDecimal)
            transferMessage = "Successfully transferred \(amount) to \(recipient)"
        } else {
            transferMessage = "Please enter recipient and amount."
        }
    }
}
