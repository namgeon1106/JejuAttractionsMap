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
    
    func checkIfFetchImageURLStringThrows(error expectedError: NetworkError) {
        let expectation = expectation(description: "Task must be executed.")
        
        Task {
            do {
                let _ = try await sut.fetchImageURLString(for: "")
                XCTFail("Error must be thrown.")
            } catch {
                XCTAssertTrue(error is NetworkError)
                XCTAssertEqual(error as? NetworkError, expectedError)
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
    func testFetchImageURLString_WhenResponseIsGood_ReturnsImageURLString() throws {
        sut = NetworkManager(session: MockURLSession(statusCode: 200, fileName: "ImageURLStringData", format: "json"))
        let expectation = expectation(description: "Task must be executed.")
        
        let dataFromFile = try Data.fromFile(fileName: "ImageURLStringData", format: "json")
        let expectedResult = try JSONDecoder().decode(ImageURLStringResponse.self, from: dataFromFile).data.first?.imageUrl
        
        Task {
            let result = try await sut.fetchImageURLString(for: "1112도로")
            XCTAssertEqual(result, expectedResult)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchImageURLString_WhenResponseHasNoImageData_ThrowsNoImage() {
        sut = NetworkManager(session: MockURLSession(statusCode: 200, fileName: "NoImageURLData", format: "json"))
        checkIfFetchImageURLStringThrows(error: .noImage)
    }
    
    func testFetchImageURLString_WhenResponseIsNoServiceError_ThrowsServiceExpired() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "NoServiceError", format: "xml"))
        checkIfFetchImageURLStringThrows(error: .serviceExpired)
    }
    
    func testFetchImageURLString_WhenResponseIsServiceAccessDeniedError_ThrowsServiceAccessDenied() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "ServiceAccessDeniedError", format: "xml"))
        checkIfFetchImageURLStringThrows(error: .serviceAccessDenied)
    }
    
    func testFetchImageURLString_WhenResponseIsRequestExceededError_ThrowsRequestExceeded() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "RequestExceededError", format: "xml"))
        checkIfFetchImageURLStringThrows(error: .requestExceeded)
    }
    
    func testFetchImageURLString_WhenResponseIsDeadlineExpiredError_ThrowsServiceExpired() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "DeadlineExpiredError", format: "xml"))
        checkIfFetchImageURLStringThrows(error: .serviceExpired)
    }
    
    func testFetchImageURLString_WhenResponseIsUnknownError_ThrowsUnknown() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "UnknownError", format: "xml"))
        checkIfFetchImageURLStringThrows(error: .unknown)
    }
    
    func testFetchImageURLString_WhenResponseIsNotXML_ThrowsUnknown() {
        sut = NetworkManager(session: MockURLSession(statusCode: 400, fileName: "NotXML", format: "json"))
        checkIfFetchImageURLStringThrows(error: .unknown)
    }
}
