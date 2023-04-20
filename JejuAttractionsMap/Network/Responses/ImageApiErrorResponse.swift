//
//  ImageApiErrorResponse.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/04/20.
//

import Foundation

struct ImageApiErrorResponse: Decodable {
    let errorMessage: String
    let errorCode: String
}
