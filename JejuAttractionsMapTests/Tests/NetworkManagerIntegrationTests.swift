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
    
    func testFetchImage_whenUsedCorrectUrl_returnsUIImage() {
        let data = try! Data.fromFile(fileName: "가릿당_관광지안내_001-1", format: "jpg")
        let expectedImage = UIImage(data: data)
        
        let expectation = expectation(description: "Task must be executed.")
        
        Task {
            do {
                let image = try await sut.fetchImage(from: "http://api.brandcontents.or.kr/jejuImage/%EA%B0%80%EB%A6%BF%EB%8B%B9_%EA%B4%80%EA%B4%91%EC%A7%80%EC%95%88%EB%82%B4_001-1.jpg")
                
                XCTAssertEqual(image.jpegData(compressionQuality: 1), expectedImage?.jpegData(compressionQuality: 1))
            } catch {
                print(error)
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
