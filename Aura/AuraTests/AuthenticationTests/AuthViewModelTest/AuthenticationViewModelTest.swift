//
//  AuthenticationViewModelTest.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 04/03/2024.
//

import XCTest
@testable import Aura

final class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    var mockAuthModel: MockAuthenticationModel!
    
    override func setUp() {
        super.setUp()
        mockAuthModel = MockAuthenticationModel()
        viewModel = AuthenticationViewModel{
            
        }
        viewModel.authModel = mockAuthModel
    }

    func testLoginSucceed() {
        let mockViewModel = MockAuthenticationViewModel { }
        mockViewModel.shouldAuthenticateSuccessfully = true

        mockViewModel.login()
        
        XCTAssertTrue(mockViewModel.isAuthenticated)
    }



    func testLoginFail() {
        let viewModel = AuthenticationViewModel { }
        viewModel.authModel = MockAuthenticationModel()
        (viewModel.authModel as! MockAuthenticationModel).shouldAuthenticateSuccessfully = false

        viewModel.login()
        
        XCTAssertFalse(viewModel.isAuthenticated)
    }
}
