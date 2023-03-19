//
//  ViewController.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/02/19.
//

import UIKit
import NMapsMap
import Combine

class MapViewController: UIViewController {
    let viewModel: MapViewModel
    var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: MapViewModel = MapViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle.main)
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        self.mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: 33.360669, lng: 126.532947), zoom: 10)))
        
        viewModel.$attractions
            .receive(on: DispatchQueue.main)
            .sink { attractions in
                (0..<attractions.count).forEach { [unowned self] index in
                    let attraction = attractions[index]
                    let marker = NMFMarker()
                    marker.zIndex = index
                    marker.isHideCollidedMarkers = true
                    marker.position = NMGLatLng(lat: attraction.latitude, lng: attraction.longitude)
                    marker.mapView = self.mapView
                    
                    marker.touchHandler = { _ in
                        self.viewModel.selectAttraction(attraction)
                        
                        return true
                    }
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$isSearching
            .map { !$0 }
            .assign(to: \.isHidden, on: searchCancelButton)
            .store(in: &subscriptions)
        
        viewModel.$isSearching
            .map { !$0 }
            .assign(to: \.isHidden, on: tableView)
            .store(in: &subscriptions)
        
        viewModel.$isSearching
            .assign(to: \.isHidden, on: mapView)
            .store(in: &subscriptions)
        
        viewModel.$searchText
            .map(Optional.init)
            .assign(to: \.text, on: searchBar)
            .store(in: &subscriptions)
        
        viewModel.$searchText
            .sink { [unowned self] _ in
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
            }
            .store(in: &subscriptions)
        
        viewModel.$filteredAttractions
            .sink { [unowned self] _ in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            .store(in: &subscriptions)
        
        viewModel.$filteredAttractions
            .delay(for: 0.05, scheduler: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$focusedAttraction
            .sink { [unowned self] attraction in
                if let attraction {
                    let sheetController = AttractionInfoSheetController()
                    self.present(sheetController, animated: true)
                    self.searchBar.endEditing(true)
                    sheetController.attraction = attraction
                    let cameraUpdate = NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: attraction.latitude, lng: attraction.longitude), zoom: 16))
                    
                    cameraUpdate.animation = .easeIn
                    cameraUpdate.animationDuration = 1
                    
                    self.mapView.moveCamera(cameraUpdate)
                } else {
                    self.dismiss(animated: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let searchBar = UISearchBar()
    let searchCancelButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return button
    }()
    
    let tableView = UITableView()
    let mapView = NMFMapView()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLayout()
    }

    func setLayout() {
        [searchBar, searchCancelButton, tableView, mapView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchCancelButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 30),
            searchCancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchCancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.filteredAttractions[indexPath.row].name
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredAttractions.count
    }
}

// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFor(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.startSearch()
        viewModel.searchFor(viewModel.searchText)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
