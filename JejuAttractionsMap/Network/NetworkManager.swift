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
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchAllAttractions() async throws -> [Attraction] {
        let url = URL(string: API.attractionsURLString)!
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
        return ""
    }
    
    func fetchImage(from urlString: String) async throws -> UIImage {
        let url = URL(string: urlString)!
        let (data, _) = try await session.data(for: URLRequest(url: url))
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.noImage
        }
        
        return image
    }
}
