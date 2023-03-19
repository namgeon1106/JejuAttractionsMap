//
//  MapViewControllerTests.swift
//  JejuAttractionsMapTests
//
//  Created by 김남건 on 2023/03/16.
//

import XCTest
@testable import JejuAttractionsMap
import NMapsMap

final class MapViewControllerTests: XCTestCase {
    func generateMapViewController() -> MapViewController {
        let vc = MapViewController(viewModel:
                    MapViewModel(isStub: true)
                )
        
        let data = try! Data.fromFile(fileName: "AttractionsData", format: "json")
        let attractions = try! JSONDecoder().decode(AttractionsResponse.self, from: data).data
        
        vc.viewModel.loadAttractions(attractions)
        return vc
    }
    
    var sut: MapViewController!
    
    override func setUpWithError() throws {
        sut = generateMapViewController()
        
        let scene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene
        
        scene?
            .windows.first(where: { $0.isKeyWindow })?
            .rootViewController = sut
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testViewController_whenInitialized_updatesUI() {
        XCTAssertEqual(sut.searchBar.text, "")
        XCTAssertEqual(sut.searchCancelButton.isHidden, true)
        XCTAssertEqual(sut.tableView.isHidden, true)
        XCTAssertEqual(sut.mapView.isHidden, false)
        XCTAssertEqual(sut.activityIndicator.isHidden, true)
        XCTAssertEqual(sut.activityIndicator.isAnimating, false)
        XCTAssertEqual(sut.presentedViewController, nil)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
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
    
    func testViewController_whenSelectAttraction_updatesUI() {
        // given
        let targetAttraction = sut.viewModel.attractions[0]
        
        // when
        sut.viewModel.selectAttraction(targetAttraction)
        
        // then
        XCTAssertEqual(sut.mapView.isHidden, false)
        XCTAssertEqual(sut.tableView.isHidden, true)
        
        XCTAssertEqual(sut.searchBar.searchTextField.isEditing, false)
        
        XCTAssertEqual(sut.mapView.cameraPosition.zoom, 12)
        XCTAssertLessThanOrEqual(abs(sut.mapView.cameraPosition.target.lat - targetAttraction.latitude), 0.001)
        XCTAssertLessThanOrEqual(abs(sut.mapView.cameraPosition.target.lng - targetAttraction.longitude), 0.001)
        
        XCTAssertEqual(sut.presentedViewController, sut.attractionInfoSheetController)
        XCTAssertEqual(sut.attractionInfoSheetController.nameLabel.text, targetAttraction.name)
        XCTAssertEqual(sut.attractionInfoSheetController.addressLabel.text, "􀋕 \(targetAttraction.newAddr ?? "주소 불명")")
        XCTAssertEqual(sut.attractionInfoSheetController.telLabel.text, "􀒥 \(targetAttraction.tel)")
        XCTAssertEqual(sut.attractionInfoSheetController.descriptionLabel.text, targetAttraction.intro)
    }
}
