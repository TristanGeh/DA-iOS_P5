//
//  AuthenticationModelMock.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 04/03/2024.
//

import Foundation
@testable import Aura

class MockAuthenticationModel: AuthenticationModel {
    var shouldAuthenticateSuccessfully = false
    
    override func authentication(username: String, password: String, completion: @escaping (Bool) -> Void) {
        completion(shouldAuthenticateSuccessfully)
    }
}
