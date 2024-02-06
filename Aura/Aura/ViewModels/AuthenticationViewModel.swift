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
    
    @Published var authToken: String?
    
    @Published var isAuthenticated: Bool = false
    
    let onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
    }
    
    func login() {
        if isEmailValid(){
            print("login with \(username) and \(password)")
            fetchAuthToken(username: username, password: password)
        }else{ print("Email non valide")}
    }
    
    func isEmailValid() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: username)
    }
    
    func fetchAuthToken(username: String, password: String) {
        guard let auth = URL(string: "http://127.0.0.1:8080/auth") else { return }
        var request = URLRequest(url: auth)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        
        let body: [String: String] = ["username": username, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        request.httpBody = jsonData

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur lors de la requête : \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("La réponse n'est pas une HTTPURLResponse")
                return
            }
            
            if httpResponse.statusCode == 200 {
                guard let data = data,
                      let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                      let token = responseJSON["token"] else {
                    print("Échec du décodage de la réponse")
                    return
                }
                
                DispatchQueue.main.async {
                    self.authToken = token
                    self.isAuthenticated = true
                    self.onLoginSucceed()
                }
            } else {
                print("Status code pas bon: \(httpResponse.statusCode)")
                if let data = data, let errorBody = String(data: data, encoding: .utf8) {
                    print("Réponse du serveur : \(errorBody)")
                }
            }
        }
        task.resume()

    }
}
