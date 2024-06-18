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
    
    func test_onLoad_successLoadingMealDetail() {
        let expectation = self.expectation(description: "Loading meal detail")
        
        let mockData = """
                    {
                        "meals": [
                            {
                                "idMeal": "52855",
                                "strMeal": "Banana Pancakes",
                                "strCategory": "Dessert",
                                "strArea": "American",
                                "strInstructions": "In a bowl, mash the banana with a fork until it resembles a thick purée. Stir in the eggs, baking powder and vanilla.\\r\\nHeat a large non-stick frying pan or pancake pan over a medium heat and brush with half the oil. Using half the batter, spoon two pancakes into the pan, cook for 1-2 mins each side, then tip onto a plate. Repeat the process with the remaining oil and batter. Top the pancakes with the pecans and raspberries.",
                                "strMealThumb": "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg",
                                "strIngredient1": "Banana",
                                "strIngredient2": "Eggs",
                                "strIngredient3": "Baking Powder",
                                "strIngredient4": "Vanilla Extract",
                                "strIngredient5": "Oil",
                                "strMeasure1": "1 large",
                                "strMeasure2": "2 medium",
                                "strMeasure3": "pinch",
                                "strMeasure4": "spinkling",
                                "strMeasure5": "1 tsp"
                            }
                        ]
                    }
                    """.data(using: .utf8)!
        
        let url = URL(string: NetworkManager.TheMealDBEndpoints.fetchMealDetail.rawValue + "52855")!
        let mockResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponses[url] = (data: mockData, response: mockResponse, error: nil)
        
        networkManager.loadMealData(from: url, session: mockSession) { (result: Result<MealsDetail, Error>) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.meals.count, 1)
                let mealDetail = data.meals.first
                XCTAssertEqual(mealDetail?.id, "52855")
                XCTAssertEqual(mealDetail?.title, "Banana Pancakes")
                XCTAssertEqual(mealDetail?.category, "Dessert")
                XCTAssertEqual(mealDetail?.area, "American")
                XCTAssertEqual(mealDetail?.instructions, "In a bowl, mash the banana with a fork until it resembles a thick purée. Stir in the eggs, baking powder and vanilla.\r\nHeat a large non-stick frying pan or pancake pan over a medium heat and brush with half the oil. Using half the batter, spoon two pancakes into the pan, cook for 1-2 mins each side, then tip onto a plate. Repeat the process with the remaining oil and batter. Top the pancakes with the pecans and raspberries.")
                XCTAssertEqual(mealDetail?.thumbnailURL, "https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg")
                XCTAssertEqual(mealDetail?.ingredients, ["• 1 large banana", "• 2 medium eggs", "• pinch baking powder", "• spinkling vanilla extract", "• 1 tsp oil"])
                
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func test_onLoad_failLoadingMealDetail() {
            let expectation = self.expectation(description: "Loading meal detail with error")
            
            let url = URL(string: NetworkManager.TheMealDBEndpoints.fetchMealDetail.rawValue + "52855")!
            MockURLProtocol.mockResponses[url] = (data: nil, response: nil, error: URLError(.notConnectedToInternet))
            
            networkManager.loadMealData(from: url, session: mockSession) { (result: Result<MealsDetail, Error>) in
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
