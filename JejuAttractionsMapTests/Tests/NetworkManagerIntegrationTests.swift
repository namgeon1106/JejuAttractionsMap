//
//  NetworkManagerIntegrationTests.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/15.
//

import XCTest
@testable import JejuAttractionsMap

final class NetworkManagerIntegrationTests: XCTestCase {
    let sut = NetworkManager(session: URLSession.shared)

    func testFetchAttractions() {
        let expectation = expectation(description: "Task must be executed.")
        
        Task {
            do {
                let attractions = try await sut.fetchAllAttractions()
                XCTAssertEqual(attractions.count, 1047)
            } catch {
                print("error: \(error)")
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
