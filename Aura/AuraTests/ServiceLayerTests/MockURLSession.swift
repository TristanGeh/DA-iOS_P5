//
//  MockURLSession.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 11/03/2024.
//

import Foundation
@testable import Aura

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?
    var lastRequest: URLRequest?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastRequest = request
        completionHandler(nextData, nextResponse, nextError)
        return MockURLSessionDataTask()
    }
}

