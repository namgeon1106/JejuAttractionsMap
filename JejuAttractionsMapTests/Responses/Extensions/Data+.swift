//
//  Data+.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/06.
//

import Foundation

extension Data {
    static func fromFile(fileName: String, format: String) throws -> Data {
        let bundle = Bundle(for: TestBundleClass.self)
        
        let path = bundle.path(forResource: fileName, ofType: format)!
        return try String(contentsOfFile: path).data(using: .utf8)!
    }
}

private class TestBundleClass {}
