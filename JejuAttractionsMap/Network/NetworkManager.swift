//
//  NetworkManager.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/07.
//

import Foundation
import XMLCoder

class NetworkManager {
    private let session: URLSessionProtocol
    private let attractionsCount = 1047
    private let serviceKey = "P6%2BlyELthAZGU%2BPOAS5mE3%2BqJX78QgOALbnBIdeZZOYnNjpa5TcB7OyWIODvx7dN1VZkMsDvEX554ddUBuYqhg%3D%3D"
    
    private var attractionsURLString: String {
        "https://apis.data.go.kr/6500000/jjtb/locinfo?serviceKey=\(serviceKey)&pageNo=1&numOfRows=\(attractionsCount)"
    }
    
    private var fetchImageInfoURLString: String {
        "https://apis.data.go.kr/6500000/jjtb/image?serviceKey=\(serviceKey)&pageNo=1&numOfRows=1&name="
    }
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchAllAttractions() async throws -> [Attraction] {
        let url = URL(string: attractionsURLString)!
        let (data, _) = try await session.data(for: URLRequest(url: url))
        
        if let attractionsResponse = try? JSONDecoder().decode(AttractionsResponse.self, from: data) {
            return attractionsResponse.data
        }
        
        guard let errorResponse = try? XMLDecoder().decode(OpenAPI_ServiceResponse.self, from: data) else {
            throw NetworkError.unknown
        }
        
        switch errorResponse.cmmMsgHeader.returnReasonCode {
        case 12, 31:
            throw NetworkError.serviceExpired
        case 20:
            throw NetworkError.serviceAccessDenied
        case 22:
            throw NetworkError.requestExceeded
        default:
            throw NetworkError.unknown
        }
    }
    
    func fetchImageURLString(for name: String) async throws -> String {
        let urlString = fetchImageInfoURLString + name
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedURLString)!
        
        let (data, _) = try await session.data(for: URLRequest(url: url))
        
        if let imageURLResponse = try? JSONDecoder().decode(ImageURLStringResponse.self, from: data) {
            if let imageURLData = imageURLResponse.data.first {
                return imageURLData.imageUrl
            } else {
                throw NetworkError.noImage
            }
        }
        
        guard let errorResponse = try? XMLDecoder().decode(OpenAPI_ServiceResponse.self, from: data) else {
            throw NetworkError.unknown
        }
        
        switch errorResponse.cmmMsgHeader.returnReasonCode {
        case 12, 31:
            throw NetworkError.serviceExpired
        case 20:
            throw NetworkError.serviceAccessDenied
        case 22:
            throw NetworkError.requestExceeded
        default:
            throw NetworkError.unknown
        }
    }
}
