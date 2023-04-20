//
//  JejuAttractionsMapTests.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/05.
//

import XCTest
import XMLCoder
@testable import JejuAttractionsMap

final class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    
    // MARK: - 에러 throw check 함수
    func checkIfFetchAllAttractionsThrows(error expectedError: AttractionsApiError) {
        let expectation = expectation(description: "Task must be executed.")
        
        Task {
            do {
                let _ = try await sut.fetchAllAttractions()
                XCTFail("Error must be thrown.")
            } catch {
                XCTAssertTrue(error is AttractionsApiError)
                XCTAssertEqual(error as? AttractionsApiError, expectedError)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - fetchAllAttractions()에 대한 테스트
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
    
    func testFetchAllAttractions_WhenResponseIsDeadlineExpiredError_ThrowsServiceExpired() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "DeadlineExpiredError", format: "xml"))
        checkIfFetchAllAttractionsThrows(error: .serviceExpired)
    }
    
    func testFetchAllAttractions_WhenResponseIsUnknownError_ThrowsUnknown() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "UnknownError", format: "xml"))
        checkIfFetchAllAttractionsThrows(error: .unknown)
    }
    
    func testFetchAllAttractions_WhenResponseIsNotXML_ThrowsUnknown() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "NotXML", format: "json"))
        checkIfFetchAllAttractionsThrows(error: .unknown)
    }
    
    // MARK: - fetchImageURLString(for:)에 대한 테스트
    
}
