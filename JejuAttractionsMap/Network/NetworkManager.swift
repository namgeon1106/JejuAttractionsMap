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
        let url = URL(string: AttracitonsApi.attractionsURLString)!
        let (data, _) = try await session.data(for: URLRequest(url: url))
        
        if let attractionsResponse = try? JSONDecoder().decode(AttractionsResponse.self, from: data) {
            return attractionsResponse.data
        }
        
        guard let errorResponse = try? XMLDecoder().decode(OpenAPI_ServiceResponse.self, from: data) else {
            throw AttractionsApiError.unknown
        }
        
        switch errorResponse.cmmMsgHeader.returnReasonCode {
        case 12, 31:
            throw AttractionsApiError.serviceExpired
        case 20:
            throw AttractionsApiError.serviceAccessDenied
        case 22:
            throw AttractionsApiError.requestExceeded
        default:
            throw AttractionsApiError.unknown
        }
    }
    
    func fetchImageURLString(for name: String) async throws -> String {
        let request = ImageApi.urlRequest(from: name)
        let (data, _) = try await session.data(for: request)
        
        if let imageUrlStringResponse = try? JSONDecoder().decode(ImageURLStringResponse.self, from: data) {
            return imageUrlStringResponse.items[0].thumbnail
        }
        
        guard let errorResponse = try? JSONDecoder().decode(ImageApiErrorResponse.self, from: data) else {
            throw ImageApiError.unknown
        }
        
        switch errorResponse.errorCode {
        case "SE01":
            throw ImageApiError.incorrectQuery
        default:
            throw ImageApiError.unknown
        }
    }
    
    func fetchImage(from urlString: String) async throws -> UIImage {
        let url = URL(string: urlString)!
        let (data, _) = try await session.data(for: URLRequest(url: url))
        
        guard let image = UIImage(data: data) else {
            throw AttractionsApiError.noImage
        }
        
        return image
    }
}
