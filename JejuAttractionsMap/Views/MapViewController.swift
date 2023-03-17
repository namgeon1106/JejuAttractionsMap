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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let searchBar = UISearchBar()
    let searchCancelButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return button
    }()
    
    let tableView = UITableView()
    let mapView = NMFNaverMapView()
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

