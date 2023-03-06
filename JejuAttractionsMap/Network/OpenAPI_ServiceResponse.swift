//
//  OpenAPI_ServiceResponse.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/07.
//

import Foundation

struct OpenAPI_ServiceResponse: Decodable {
    let cmmMsgHeader: Header
    
    struct Header: Decodable {
        let errMsg: String
        let returnAuthMsg: String
        let returnReasonCode: Int
    }
}
