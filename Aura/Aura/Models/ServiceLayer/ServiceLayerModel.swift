//
//  ServiceLayerModel.swift
//  Aura
//
//  Created by Tristan Géhanne on 11/02/2024.
//

import Foundation
class ServiceLayer: ObservableObject {
    
    // MARK: - Set variables
    
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    static var authToken: String?
    var accountDetails: AccountDetail?
    
    struct TransferRequestBody: Codable {
        let recipient: String
        let amount: Decimal
    }
    
    
    // MARK: - API calls
    
    
    func fetchAuthToken(username: String, password: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: ServiceLayerConfiguration.baseUrl + ServiceLayerConfiguration.authEndpoint) else { return }
        let bodyDict = ["username": username, "password": password]
        let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
        let request = ServiceLayerConfiguration.createRequest(url: url, method: "POST", headers: ["Content-Type": "application/json"], body: body)

        
        let task = self.session.dataTask(with: request) { data, response, error in
            let treatedData = ServiceLayerConfiguration.treatResult(data: data, response: response, error: error)
            
            if let resultData = treatedData {
                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: resultData),
                      let token = responseJSON["token"] else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    print("Échec du décodage de la réponse")
                    return
                }
                ServiceLayer.authToken = token
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
    
    func fetchAccountDetail() {
        guard let url = URL(string: ServiceLayerConfiguration.baseUrl + ServiceLayerConfiguration.accountEndpoint), let authToken = ServiceLayer.authToken else { return }
        let headers = ["token": "\(authToken)"]
        let request = ServiceLayerConfiguration.createRequest(url: url, method: "GET", headers: headers)
        
        
        let task = session.dataTask(with: request) { data, response, error in
            let treatedData = ServiceLayerConfiguration.treatResult(data: data, response: response, error: error)
            if let data = treatedData {
                let responseJSON = try? JSONDecoder().decode(AccountDetail.self, from: data)
                self.accountDetails = responseJSON
            }
        }
        task.resume()
    }
    
    func sendMoneyTransfer(recipient: String, amount: Decimal) {
        guard let url = URL(string: ServiceLayerConfiguration.baseUrl + ServiceLayerConfiguration.accountEndpoint + ServiceLayerConfiguration.moneyTransferEndpoint) else { return }
        let bodyTrans = TransferRequestBody(recipient: recipient, amount: amount)
        let body = try? JSONEncoder().encode(bodyTrans)
        let request = ServiceLayerConfiguration.createRequest(url: url, method: "POST", headers: ["Content-Type" : "application/json"], body: body)
        
        
        let task = session.dataTask(with: request) { data, response, error in
            ServiceLayerConfiguration.treatResult(data: data, response: response, error: error)
        }
        task.resume()
    }
}
