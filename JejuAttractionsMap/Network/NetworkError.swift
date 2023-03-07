//
//  NetworkError.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/07.
//

import Foundation

enum NetworkError: Error {
    case serviceExpired, serviceAccessDenied, requestExceeded, unknown
}
