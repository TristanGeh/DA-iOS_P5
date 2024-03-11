//
//  AuthenticationModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 11/02/2024.
//

import Foundation
class AuthenticationModel {
    var serviceLayer = ServiceLayer()
    
    func isEmailValid(username: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: username)
    }
    
    func isPasswordFilled(password: String) -> Bool {
        return !password.isEmpty
    }
    
    func authentication(username: String, password: String, completion: @escaping (Bool) -> Void) {
        serviceLayer.fetchAuthToken(username: username, password: password) { success in
           completion(success)
        }
    }
}
