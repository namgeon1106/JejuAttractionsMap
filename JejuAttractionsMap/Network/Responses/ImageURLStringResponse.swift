//
//  ImageURLStringResponse.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/09.
//

import Foundation

struct ImageURLStringResponse: Decodable {
    let data: [ImageURLResult]
    
    struct ImageURLResult: Decodable {
        let imageUrl: String
    }
}
