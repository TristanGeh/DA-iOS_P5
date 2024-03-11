//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {
    var serviceLayer = ServiceLayer()
    
    @Published var recentTransactions: [Transaction] = []
    
    @Published var totalAmount: String = ""
    
    func loadRecentTransactions() {
        serviceLayer.fetchAccountDetail()
        DispatchQueue.main.async {
            if let accountDetails = self.serviceLayer.accountDetails {
                self.recentTransactions = Array(accountDetails.transactions.prefix(3))
                self.totalAmount = "\(accountDetails.currentBalance)"
            }
        }
    }
    
}
