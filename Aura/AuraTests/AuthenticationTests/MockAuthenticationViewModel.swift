//
//  File.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 04/03/2024.
//

import Foundation
@testable import Aura

class MockAuthenticationViewModel: AuthenticationViewModel {
    var shouldAuthenticateSuccessfully = false

    override func login() {
        if shouldAuthenticateSuccessfully {
            self.isAuthenticated = true
            self.onLoginSucceed()
        } else {
            print("Erreur d'authentification")
        }
    }
}

