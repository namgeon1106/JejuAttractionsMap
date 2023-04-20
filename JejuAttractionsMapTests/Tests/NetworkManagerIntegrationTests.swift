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
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testFetchImage_whenUsedWrongUrl_throwsNoImageError() {
        let expectation = expectation(description: "Task must be executed.")
        
        Task {
            do {
                let _ = try await sut.fetchImage(from: "http://api.brandcontents.or.kr/jejuImage/%EA%B0%80%EB%A6%BF%EB%8B%B9_%EA%B4%80%EA%B4%91%EC%A7%80%EC%95%88%EB%82%B4_001-154.jpg")
                
                XCTFail()
            } catch {
                XCTAssertEqual(error as? AttractionsApiError, AttractionsApiError.noImage)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testFetchImageUrlString() {
        let expectation = expectation(description: "Task must be executed.")
        
        Task {
            do {
                let result = try await sut.fetchImageURLString(for: "성산일출봉")
                XCTAssertEqual(result, "https://search.pstatic.net/sunny/?type=b150&src=https://resource.tranggle.com/board_v3/story/2022/20220531/231404_3a11dd9c98ea1f6288b3d1700430626dda41293d_960x.jpg")
            } catch {
                print("error: \(error)")
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
