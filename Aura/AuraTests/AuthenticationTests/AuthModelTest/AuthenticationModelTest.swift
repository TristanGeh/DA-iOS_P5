//
//  AuthenticationModel.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 27/02/2024.
//

import XCTest
@testable import Aura

final class AuthenticationModelTests: XCTestCase {
    var model: AuthenticationModel!
    var mockServiceLayer: MockServiceLayer!
    
    override func setUp() {
        super.setUp()
        mockServiceLayer = MockServiceLayer()
        model = AuthenticationModel()
    }
    
    func testIsEmailValid_ValidEmail_ReturnsTrue() {
        XCTAssertTrue(model.isEmailValid(username: "test@example.com"))
    }
    
    func testIsPasswordFilled_PasswordFilled_ReturnsTrue() {
        XCTAssertTrue(model.isPasswordFilled(password: "password123"))
    }
    
    func testAuthenticationSuccessfull() {
        mockServiceLayer.shouldFetchAuthTokenSucceed = true
        
        model.authentication(username: "test@example.com", password: "test123") { success in
            XCTAssertTrue(success)
        }
    }
    
    func testAuthenticationUnsuccessfull() {
        mockServiceLayer.shouldFetchAuthTokenSucceed = false
        
        model.authentication(username: "test@example.com", password: "test123") { success in
            XCTAssertFalse(success)
        }
    }
    
    
    
    
    override func tearDown() {
        mockServiceLayer = nil
        model = nil
        super.tearDown()
    }
}

