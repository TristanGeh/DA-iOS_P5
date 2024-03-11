//
//  AllTransactionViewModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 12/02/2024.
//

import Foundation

class AllTransactionViewModel: ObservableObject {
    var serviceLayer = ServiceLayer()
    
    @Published var allTransactions: [Transaction] = []
    
    func loadAllTransactions() {
        serviceLayer.fetchAccountDetail()
        DispatchQueue.main.async {
            if let accountDetails = self.serviceLayer.accountDetails {
                self.allTransactions = accountDetails.transactions
            }
        }
    }
}
