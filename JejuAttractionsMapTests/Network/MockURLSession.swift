//
//  MockURLSession.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/07.
//

import Foundation
@testable import JejuAttractionsMap

class MockURLSession: URLSessionProtocol {
    let statusCode: Int
    let data: Data
    
    init(statusCode: Int, fileName: String, format: String) {
        self.statusCode = statusCode
        self.data = try! Data.fromFile(fileName: fileName, format: format)
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return (data, HTTPURLResponse(url: URL(string: "www.naver.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!)
    }
}
