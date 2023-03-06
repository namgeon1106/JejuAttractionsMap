//
//  Attraction.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/07.
//

import Foundation

struct Attraction: Decodable {
    let infoId: Int
    let name: String
    let newAddr: String
    let latitude: Double
    let longitude: Double
    let tel: String
    let intro: String
    
    private enum CodingKeys: String, CodingKey {
        case infoId, name, newAddr, latitude, longitude, tel, intro
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        infoId = try Int(container.decode(String.self, forKey: .infoId)) ?? 0
        name = try container.decode(String.self, forKey: .name)
        newAddr = try container.decode(String.self, forKey: .newAddr)
        latitude = try Double(container.decode(String.self, forKey: .latitude)) ?? 0
        longitude = try Double(container.decode(String.self, forKey: .longitude)) ?? 0
        tel = try container.decode(String.self, forKey: .tel)
        intro = try container.decode(String.self, forKey: .intro)
    }
}
