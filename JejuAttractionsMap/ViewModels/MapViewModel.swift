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
    
    init(networkManager: NetworkManager = NetworkManager(session: URLSession.shared), isStub: Bool = false) {
        self.networkManager = networkManager
        
        if isStub { return }
        Task {
            do {
                let attractions = try await networkManager.fetchAllAttractions()
                loadAttractions(attractions)
            } catch {
                print(error)
            }
        }
    }
    
    func loadAttractions(_ attractions: [Attraction]) {
        self.attractions = attractions
    }
    
    func initializeState() {
        isSearching = false
        searchText = ""
        filteredAttractions = attractions
        focusedAttraction = nil
    }
}
