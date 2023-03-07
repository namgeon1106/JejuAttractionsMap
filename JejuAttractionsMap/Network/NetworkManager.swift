//
//  NetworkManager.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/07.
//

import Foundation

class NetworkManager {
    let session: URLSessionProtocol
    let attractionsCount = 1047
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchAllAttractions() async throws -> [Attraction] {
        return []
    }
}
