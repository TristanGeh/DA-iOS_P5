//
//  MockURLSessionDataTask.swift
//  AuraTests
//
//  Created by Tristan Géhanne on 11/03/2024.
//

import Foundation
@testable import Aura

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var isResumeCalled = false

    func resume() {
        isResumeCalled = true
    }
}

