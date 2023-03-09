//
//  Data+.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/06.
//

import Foundation
import XCTest

extension Data {
    static func fromFile(fileName: String, format: String) throws -> Data {
        let bundle = Bundle(for: TestBundleClass.self)
        let url = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: format),
                                "Unable to find \(fileName).json. Did you add it to the tests?",
                                file: #file, line: #line)
        return try Data(contentsOf: url)
    }
}

private class TestBundleClass {}
