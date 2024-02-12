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
    
    private var authModel = AuthenticationModel()
    
    let onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
    }
    
    func login() {
        guard authModel.isEmailValid(username: username) && authModel.isPasswordFilled(password: password) else {
                print("Email non valide")
                return
            }
            
        authModel.authService(username: username, password: password, viewModel: self)
        }
}
