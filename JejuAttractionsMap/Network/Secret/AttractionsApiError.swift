//
//  NetworkError.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/07.
//

import Foundation

enum AttractionsApiError: Error {
    case serviceExpired, serviceAccessDenied, requestExceeded, unknown, noImage
}
