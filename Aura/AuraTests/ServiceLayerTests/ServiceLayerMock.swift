//
//  ServiceLayerMock.swift
//  Aura
//
//  Created by Tristan Géhanne on 27/02/2024.
//

import Foundation
class MockServiceLayer: ServiceLayerProtocol {
    var mockAuthToken: String?
    var mockAccountDetails: AccountDetail?
    var sendMoneySuccess: Bool = true
    var shouldAuthenticateSuccessfully: Bool = false
    var simulatedHttpStatusCode: Int = 200
    var error: Error?
    var shouldReturnError: Bool = false

    func fetchAuthToken(username: String, password: String, completion: @escaping (Bool) -> Void) {
        completion(shouldAuthenticateSuccessfully)
    }

    func fetchAccountDetail(completion: @escaping (AccountDetail?, Error?) -> Void) {
        if let error = self.error {
            completion(nil, error)
        } else {
            completion(mockAccountDetails, nil)
        }
    }


    func sendMoneyTransfer(recipient: String, amount: Decimal, completion: @escaping (Bool, Error?) -> Void) {
        let success = simulatedHttpStatusCode == 200
        completion(sendMoneySuccess, nil)
    }
}
