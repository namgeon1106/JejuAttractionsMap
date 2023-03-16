//
//  MapViewModel.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/16.
//

import Foundation

class MapViewModel {
    let networkManager: NetworkManager
    @Published private(set) var attractions = [Attraction]()
    
    @Published private(set) var isSearching = false
    @Published private(set) var searchText = ""
    @Published private(set) var filteredAttractions = [Attraction]()
    
    @Published private(set) var focusedAttraction: Attraction? = nil
    
    init(networkManager: NetworkManager = NetworkManager(session: URLSession.shared)) {
        self.networkManager = networkManager
        
        Task {
            do {
                self.attractions = try await networkManager.fetchAllAttractions()
            } catch {
                print(error)
            }
        }
    }
}
