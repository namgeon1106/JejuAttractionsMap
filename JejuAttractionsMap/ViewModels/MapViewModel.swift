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
        
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map { text in
                if text == "" { return self.attractions }
                
                let filtered = self.attractions.filter { attraction in
                    attraction.name.contains(text)
                }
                return filtered
            }
            .assign(to: &$filteredAttractions)
        
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
    
    func startSearch() {
        isSearching = true
        focusedAttraction = nil
    }
    
    func cancelSearch() {
        searchText = ""
        isSearching = false
    }
    
    func searchFor(_ searchText: String) {
        self.searchText = searchText
    }
    
    func selectAttraction(_ attraction: Attraction) {
        focusedAttraction = attraction
        isSearching = false
    }
}
