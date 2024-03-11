//
//  URLSessionProtocol.swift
//  Aura
//
//  Created by Tristan Géhanne on 11/03/2024.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}


extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
