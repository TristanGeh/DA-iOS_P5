//
//  ServiceLayerConfiguration.swift
//  Aura
//
//  Created by Tristan Géhanne on 10/03/2024.
//

import Foundation
class ServiceLayerConfiguration {
    static let baseUrl = "http://127.0.0.1:8080"
    static let authEndpoint = "/auth"
    static let accountEndpoint = "/account"
    static let moneyTransferEndpoint = "/transfer"
    
    // MARK: - API Configuration
    
    
    static func createRequest(url: URL, method: String, headers:[String: String]? = nil, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
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
