//
//  MapViewControllerTests.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/16.
//

import XCTest
@testable import JejuAttractionsMap

final class MapViewControllerTests: XCTestCase {
    let sut = {
        let vc = MapViewController(viewModel:
                    MapViewModel(isStub: true)
                )
        
        let data = try! Data.fromFile(fileName: "AttractionsData", format: "json")
        let attractions = try! JSONDecoder().decode(AttractionsResponse.self, from: data).data
        
        vc.viewModel.loadAttractions(attractions)
        
        return vc
    }()
    
    override func setUpWithError() throws {
        sut.viewModel.initializeState()
    }

}
