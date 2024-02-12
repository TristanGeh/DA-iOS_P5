//
//  AllTransactionViewModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 12/02/2024.
//

import Foundation

class AllTransactionViewModel: ObservableObject {
    @Published var allTransactions: [Transaction] = []
    
    func loadAllTransactions() {
        ServiceLayer.fetchAccountDetail()
        DispatchQueue.main.async {
            if let accountDetails = ServiceLayer.accountDetails {
                self.allTransactions = accountDetails.transactions
            }
        }
    }
}
