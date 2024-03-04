//
//  ServiceLayerProtocol.swift
//  Aura
//
//  Created by Tristan Géhanne on 27/02/2024.
//

import Foundation
protocol ServiceLayerProtocol {
    func fetchAuthToken(username: String, password: String, completion: @escaping (Bool) -> Void)
    func fetchAccountDetail(completion: @escaping (AccountDetail?, Error?) -> Void)
    func sendMoneyTransfer(recipient: String, amount: Decimal, completion: @escaping (Bool, Error?) -> Void)
}
