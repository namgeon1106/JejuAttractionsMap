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
}
