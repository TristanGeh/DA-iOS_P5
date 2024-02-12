//
//  ServiceLayerModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 11/02/2024.
//

import Foundation
class ServiceLayer: ObservableObject {
    
    static private var authToken: String?
    static var accountDetails: AccountDetail?
    
    
    static func fetchAuthToken(username: String, password: String) {
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
                authToken = token
            } else {
                print("Status code pas bon: \(httpResponse.statusCode)")
                if let data = data, let errorBody = String(data: data, encoding: .utf8) {
                    print("Réponse du serveur : \(errorBody)")
                }
            }
        }
        task.resume()
        
    }
    
    static func fetchAccountDetail() {
        guard let accountURL = URL(string: "http://127.0.0.1:8080/account"), let authToken = authToken else { return }
        var request = URLRequest(url: accountURL)
        request.httpMethod = "GET"
        request.setValue(authToken, forHTTPHeaderField: "token")
        
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
                guard let data = data, let responseJSON = try? JSONDecoder().decode(AccountDetail.self, from: data) else {
                            print("Échec du décodage de la réponse")
                            return
                        }
                        self.accountDetails = responseJSON
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
