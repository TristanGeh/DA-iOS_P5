//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isAuthenticated: Bool = false
    
    var authModel = AuthenticationModel()
    
    let onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
    }
    
    func login() {
        guard authModel.isEmailValid(username: username) && authModel.isPasswordFilled(password: password) else {
            print("Email non valide")
            return
        }
        
        authModel.authentication(username: username, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    self.onLoginSucceed()
                }else {
                    print("Erreur d'authentification")
                }
            }
        }
    }
}
