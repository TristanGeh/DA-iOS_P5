//
//  AccountDetailModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 12/02/2024.
//

import Foundation
struct AccountDetail: Codable {
    let currentBalance : Decimal
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let label: String
    let value: Decimal
}
