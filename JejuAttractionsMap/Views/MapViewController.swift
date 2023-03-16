//
//  ViewController.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/02/19.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController {
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
        ])
        
        tableView.isHidden = true
        searchCancelButton.isHidden = true
    }
}

