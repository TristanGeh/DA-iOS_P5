//
//  ServiceLayerModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 11/02/2024.
//

import Foundation
class ServiceLayer: ObservableObject {
    
    static var authToken: String?
    static var accountDetails: AccountDetail?
    
    struct TransferRequestBody: Codable {
        let recipient: String
        let amount: Decimal
    }
    
    
    static func fetchAuthToken(username: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let auth = URL(string: "http://127.0.0.1:8080/auth") else {
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        var request = URLRequest(url: auth)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let body: [String: String] = ["username": username, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { 
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let treatedData = treatResult(data: data, response: response, error: error)
            
            if let resultData = treatedData {
                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: resultData),
                      let token = responseJSON["token"] else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    print("Échec du décodage de la réponse")
                    return
                }
                authToken = token
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
                print("Reponse invalide")
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
            let treatedData = treatResult(data: data, response: response, error: error)
            if let data = treatedData {
                let responseJSON = try? JSONDecoder().decode(AccountDetail.self, from: data)
                self.accountDetails = responseJSON
            }
        }
        task.resume()
    }
    
    static func sendMoneyTransfer(recipient: String, amount: Decimal) {
        guard let moneyUrl = URL(string: "http://127.0.0.1:8080/account/transfer") else { return }
        var request = URLRequest(url: moneyUrl)
        
        let requestBody = TransferRequestBody(recipient: recipient, amount: amount)
        let jsonData = try? JSONEncoder().encode(requestBody)
        
        request.httpMethod = "POST"
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            treatResult(data: data, response: response, error: error)
        }
        task.resume()
    }
    
    static func treatResult(data: Data?, response: URLResponse?, error: Error?) -> Data? {
        if let error = error {
            print("Erreur lors de la requête : \(error.localizedDescription)")
            return nil
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            print("La reponse n'est pas une HTTPURLResponse")
            return nil
        }
        if httpResponse.statusCode == 200 {
            guard let data = data else {
                print("Échec du décodage de la réponse")
                return nil
            }
            return data
        }else {
            print("Status code pas bon: \(httpResponse.statusCode)")
            if let data = data, let errorBody = String(data: data, encoding: .utf8) {
                print("Réponse du serveur : \(errorBody)")
                return nil
            }
        }
        return nil
    }
}
