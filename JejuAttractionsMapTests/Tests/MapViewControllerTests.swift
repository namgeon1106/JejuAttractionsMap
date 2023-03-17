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

    func testViewController_whenInitialized_updatesUI() {
        XCTAssertEqual(sut.searchBar.text, "")
        XCTAssertEqual(sut.searchCancelButton.isHidden, true)
        XCTAssertEqual(sut.tableView.isHidden, true)
        XCTAssertEqual(sut.mapView.isHidden, false)
        XCTAssertEqual(sut.activityIndicator.isHidden, true)
        XCTAssertEqual(sut.activityIndicator.isAnimating, false)
    }
    
    func testViewController_whenStartsSearch_updatesUI() {
        sut.viewModel.startSearch()
        
        XCTAssertEqual(sut.searchCancelButton.isHidden, false)
        XCTAssertEqual(sut.tableView.isHidden, false)
        XCTAssertEqual(sut.mapView.isHidden, true)
        XCTAssertEqual(sut.activityIndicator.isHidden, true)
        XCTAssertEqual(sut.activityIndicator.isAnimating, false)
    }
    
    func testViewController_whenCancelsSearch_updateUI() {
        // given
        sut.viewModel.startSearch()
        
        // when
        sut.viewModel.cancelSearch()
        
        // then
        XCTAssertEqual(sut.searchBar.text, "")
        XCTAssertEqual(sut.tableView.isHidden, true)
        XCTAssertEqual(sut.mapView.isHidden, false)
    }
}
