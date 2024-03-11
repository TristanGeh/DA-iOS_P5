//
//  AuraServiceLayerTests.swift
//  Aura
//
//  Created by Tristan Géhanne on 27/02/2024.
//

import XCTest
@testable import Aura

class ServiceLayerTests: XCTestCase {
    var mockURLSession: MockURLSession!
    var serviceLayer: ServiceLayer!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        serviceLayer = ServiceLayer(session: mockURLSession)
    }
    
    // MARK: - ServiceLAyerTests
    
    func testFetchAuthTokenSuccess() {
        let expectation = self.expectation(description: "fetchAuthToken succeeds")
        
        let sampleData = "{\"token\": \"testToken\"}".data(using: .utf8)
        mockURLSession.nextData = sampleData
        mockURLSession.nextResponse = HTTPURLResponse(url: URL(string: ServiceLayerConfiguration.baseUrl)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        var resultSuccess: Bool?
        serviceLayer.fetchAuthToken(username: "test", password: "password") { success in
            resultSuccess = success
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
            XCTAssertTrue(resultSuccess == true)
            XCTAssertEqual(ServiceLayer.authToken, "testToken")
        }
    }
    
    func testFetchAuthTokenFailure() {
        let expectation = self.expectation(description: "fetchAuthToken fails")
        
        mockURLSession.nextData = nil
        mockURLSession.nextResponse = HTTPURLResponse(url: URL(string: ServiceLayerConfiguration.baseUrl)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockURLSession.nextError = NSError(domain: "TestError", code: 0, userInfo: nil)
        
        var resultSuccess: Bool?
        serviceLayer.fetchAuthToken(username: "test", password: "password") { success in
            resultSuccess = success
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
            XCTAssertFalse(resultSuccess == true)
            XCTAssertNil(ServiceLayer.authToken)
        }
    }
    func testFetchAuthTokenInvalidData() {
        let expectation = self.expectation(description: "fetchAuthToken with invalid data")
        
        let sampleData = "{\"invalid\": \"data\"}".data(using: .utf8)
        mockURLSession.nextData = sampleData
        mockURLSession.nextResponse = HTTPURLResponse(url: URL(string: ServiceLayerConfiguration.baseUrl)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.nextError = nil
        
        var resultSuccess: Bool?
        serviceLayer.fetchAuthToken(username: "test", password: "password") { success in
            resultSuccess = success
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
            XCTAssertFalse(resultSuccess ?? true, "The completion handler should be called with 'false'")
            XCTAssertNil(ServiceLayer.authToken, "authToken should remain nil on failure")
        }
    }
    
    func testFetchAccountDetailRequestHeaders() {
        let expectedToken = "token123"
        ServiceLayer.authToken = expectedToken

        serviceLayer.fetchAccountDetail()

        XCTAssertNotNil(mockURLSession.lastRequest)

        let tokenValue = mockURLSession.lastRequest?.value(forHTTPHeaderField: "token")
        XCTAssertEqual(tokenValue, expectedToken)
    }

    
    func testFetchAccountDetailSuccess() {
        let expectation = self.expectation(description: "Completion handler called")
        
        let sampleData = """
        {
            "currentBalance": 1000.00,
            "transactions": [
                {"label": "Transaction1", "value": 100.00},
                {"label": "Transaction2", "value": -50.00}
            ]
        }
        """.data(using: .utf8)!
                
        ServiceLayer.authToken = "validToken"

        mockURLSession.nextData = sampleData
        mockURLSession.nextResponse = HTTPURLResponse(url: (URL(string: ServiceLayerConfiguration.baseUrl + ServiceLayerConfiguration.accountEndpoint)!), statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.nextError = nil
        
        serviceLayer.fetchAccountDetail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.serviceLayer.accountDetails)
            XCTAssertEqual(self.serviceLayer.accountDetails?.currentBalance, Decimal(1000.00))
            XCTAssertEqual(self.serviceLayer.accountDetails?.transactions.count, 2)
            XCTAssertEqual(self.serviceLayer.accountDetails?.transactions.first?.label, "Transaction1")
            XCTAssertEqual(self.serviceLayer.accountDetails?.transactions.first?.value, Decimal(100.00))
            XCTAssertEqual(self.serviceLayer.accountDetails?.transactions.last?.label, "Transaction2")
            XCTAssertEqual(self.serviceLayer.accountDetails?.transactions.last?.value, Decimal(-50.00))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }



    func testFetchAccountDetailFailure() {
        let expectation = self.expectation(description: "fetchAccountDetail failure")
        
        let url = URL(string: ServiceLayerConfiguration.baseUrl + ServiceLayerConfiguration.accountEndpoint)!
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        let error = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        mockURLSession.nextData = nil
        mockURLSession.nextResponse = response
        mockURLSession.nextError = error
        
        serviceLayer.fetchAccountDetail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.serviceLayer.accountDetails)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
        }
    }

    
    func testSendMoneyTransferSuccess() {
        let expectation = self.expectation(description: "SendMoneyTransfer succeeds")

        let url = URL(string: ServiceLayerConfiguration.baseUrl + ServiceLayerConfiguration.accountEndpoint + ServiceLayerConfiguration.moneyTransferEndpoint)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockURLSession.nextData = Data()
        mockURLSession.nextResponse = response
        mockURLSession.nextError = nil

        serviceLayer.sendMoneyTransfer(recipient: "test@example.com", amount: 100.00)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }

    func testSendMoneyTransferFailure() {
        let expectation = self.expectation(description: "SendMoneyTransfer fails")

        let _ = URL(string: ServiceLayerConfiguration.baseUrl + ServiceLayerConfiguration.accountEndpoint + ServiceLayerConfiguration.moneyTransferEndpoint)!
        let error = NSError(domain: "TestError", code: 400, userInfo: nil)

        mockURLSession.nextData = nil
        mockURLSession.nextResponse = nil
        mockURLSession.nextError = error

        serviceLayer.sendMoneyTransfer(recipient: "test@example.com", amount: 100.00)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    // MARK: - ServiceLayerConfiguration Tests
    func testCreateRequest() {
            let url = URL(string: "http://example.com")!
            let method = "GET"
            let headers = ["Header1": "Value1"]
            let bodyData = "Test body".data(using: .utf8)
            
            let request = ServiceLayerConfiguration.createRequest(url: url, method: method, headers: headers, body: bodyData)
            
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, method)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Header1"), "Value1")
            XCTAssertEqual(request.httpBody, bodyData)
        }
        
        func testTreatResultSuccess() {
            let sampleData = "Test data".data(using: .utf8)
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            let resultData = ServiceLayerConfiguration.treatResult(data: sampleData, response: response, error: nil)
            
            XCTAssertEqual(resultData, sampleData)
        }
        
        func testTreatResultFailure() {
            let error = NSError(domain: "TestError", code: -1, userInfo: nil)
            let resultData = ServiceLayerConfiguration.treatResult(data: nil, response: nil, error: error)
            
            XCTAssertNil(resultData)
        }
        
        func testTreatResultInvalidStatusCode() {
            let sampleData = "Test data".data(using: .utf8)
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
            
            let resultData = ServiceLayerConfiguration.treatResult(data: sampleData, response: response, error: nil)
            
            XCTAssertNil(resultData)
        }

       
       override func tearDown() {
           serviceLayer = nil
           mockURLSession = nil
           ServiceLayer.authToken = nil

           super.tearDown()
       }
    
}
