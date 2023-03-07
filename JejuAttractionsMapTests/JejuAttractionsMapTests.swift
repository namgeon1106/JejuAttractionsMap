//
//  JejuAttractionsMapTests.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/05.
//

import XCTest
import XMLCoder
@testable import JejuAttractionsMap

final class JejuAttractionsMapTests: XCTestCase {
    var sut: NetworkManager!
    
    func checkIfFetchAllAttractionsThrows(error expectedError: NetworkError) {
        let expectation = expectation(description: "Task must be executed.")
        
        Task {
            do {
                let _ = try await sut.fetchAllAttractions()
                XCTFail("Error must be thrown.")
            } catch {
                XCTAssertTrue(error is NetworkError)
                XCTAssertEqual(error as? NetworkError, expectedError)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchAllAttractions_WhenResponseIsGood_ReturnsAttractions() throws {
        sut = NetworkManager(session: MockURLSession(statusCode: 200, fileName: "AttractionsData", format: "json"))
        let expectation = expectation(description: "Task must be executed.")
        
        let dataFromFile = try Data.fromFile(fileName: "AttractionsData", format: "json")
        let expectedResult = try JSONDecoder().decode(AttractionsResponse.self, from: dataFromFile).data
        
        Task {
            let result = try await sut.fetchAllAttractions()
            XCTAssertEqual(result, expectedResult)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchAllAttractions_WhenResponseIsNoServiceError_ThrowsServiceExpired() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "NoServiceError", format: "xml"))
        checkIfFetchAllAttractionsThrows(error: .serviceExpired)
    }
    
    func testFetchAllAttractions_WhenResponseIsServiceAccessDeniedError_ThrowsServiceAccessDenied() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "ServiceAccessDeniedError", format: "xml"))
        checkIfFetchAllAttractionsThrows(error: .serviceAccessDenied)
    }
    
    func testFetchAllAttractions_WhenResponseIsRequestExceededError_ThrowsRequestExceeded() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "RequestExceededError", format: "xml"))
        checkIfFetchAllAttractionsThrows(error: .requestExceeded)
    }
}
