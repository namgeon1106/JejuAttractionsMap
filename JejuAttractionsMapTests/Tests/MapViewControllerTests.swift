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
        
        let expectation = expectation(description: "Wait for debounce operator.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
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
    
    func testViewController_whenSearchForText_updatesUI() {
        // given
        sut.viewModel.startSearch()
        
        // when
        sut.viewModel.searchFor("1112")
        
        // then
        XCTAssertEqual(sut.searchBar.text, "1112")
        XCTAssertEqual(sut.activityIndicator.isHidden, false)
        XCTAssertEqual(sut.activityIndicator.isAnimating, true)
        
        let expectation = expectation(description: "Wait for debounce publisher.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.activityIndicator.isHidden, true)
            XCTAssertEqual(self.sut.activityIndicator.isAnimating, false)
            
            let expectedCount = self.sut.viewModel.attractions.filter { attraction in
                attraction.name.contains("1112")
            }.count
            
            XCTAssertEqual(self.sut.tableView.numberOfRows(inSection: 0), expectedCount)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
