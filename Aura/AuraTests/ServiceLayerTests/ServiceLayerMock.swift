//
//  ServiceLayerMock.swift
//  Aura
//
//  Created by Tristan Géhanne on 27/02/2024.
//

import Foundation
@testable import Aura

final class MockServiceLayer: ServiceLayerProtocol {
    var shouldFetchAuthTokenSucceed = true
    var mockToken = "testToken"
    var mockAccountDetails: AccountDetail?
    var shouldSendMoneySucceed = true
    
    var mockError: Error?
    
    func fetchAuthToken(username: String, password: String, completion: @escaping (Bool) -> Void) {
        completion(shouldFetchAuthTokenSucceed)
    }
    
    func fetchAccountDetail(completion: @escaping (AccountDetail?, Error?) -> Void) {
            if let accountDetails = mockAccountDetails {
                completion(accountDetails, nil)
            } else if let error = mockError {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
        }
    
    func sendMoneyTransfer(recipient: String, amount: Decimal, completion: @escaping (Bool, Error?) -> Void) {
        if shouldSendMoneySucceed {
            completion(true, nil)
        } else {
            let error = NSError(domain: "com.MockServiceLayer", code: 500, userInfo: nil)
            completion(false, error)
        }
    }
}
