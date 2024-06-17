//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by Dan Pham on 6/17/24.
//

import XCTest
@testable import Fetch_Coding_Exercise

final class NetworkTests: XCTestCase {

    var networkManager: NetworkManager!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
    }
    
    override func tearDown() {
        networkManager = nil
        MockURLProtocol.mockResponses = [:]
        mockSession = nil
        super.tearDown()
    }
    
    func test_onLoad_successLoadingDesserts() {
        let expectation = self.expectation(description: "Loading desserts")
        
        let mockData = """
                {
                    "meals": [
                        {
                            "idMeal": "1",
                            "strMeal": "Test Dessert",
                            "strMealThumb": "test-thumbnail-url.jpg"
                        }
                    ]
                }
                """.data(using: .utf8)!
        
        let url = URL(string: NetworkManager.TheMealDBEndpoints.dessertCategory.rawValue)!
        let mockResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponses[url] = (data: mockData, response: mockResponse, error: nil)
        
        print("mockData", mockData)
        
        networkManager.loadMealData(from: url, session: mockSession) { (result: Result<Meals, Error>) in
            switch result {
            case .success(let data):
                print("data", data)
                
                XCTAssertEqual(data.meals.count, 1)
                XCTAssertEqual(data.meals.first?.id, "1")
                XCTAssertEqual(data.meals.first?.title, "Test Dessert")
                XCTAssertEqual(data.meals.first?.thumbnailURL, "test-thumbnail-url.jpg")
                
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func test_onLoad_failLoadingDesserts() {
        let expectation = self.expectation(description: "Loading desserts with error")
        
        let url = URL(string: NetworkManager.TheMealDBEndpoints.dessertCategory.rawValue)!
        MockURLProtocol.mockResponses[url] = (data: nil, response: nil, error: URLError(.notConnectedToInternet))
        
        networkManager.loadMealData(from: url, session: mockSession) { (result: Result<Meals, Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
                
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func test_onLoad_failWithInvalidURL() {
        let expectation = self.expectation(description: "Invalid URL")
        
        networkManager.loadMealData(from: nil, session: mockSession) { (result: Result<Meals, Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
                
            case .failure(let error):
                XCTAssertEqual(error as? NetworkManager.URLError, NetworkManager.URLError.invalidURL)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

}


class MockURLProtocol: URLProtocol {
    static var mockResponses: [URL: (data: Data?, response: URLResponse?, error: Error?)] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url, let mockResponse = MockURLProtocol.mockResponses[url] else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        if let data = mockResponse.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = mockResponse.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = mockResponse.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
