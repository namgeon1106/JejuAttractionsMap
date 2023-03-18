//
//  AttractionInfoSheetController.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/18.
//

import UIKit

class AttractionInfoSheetController: UIViewController, UISheetPresentationControllerDelegate {
    var attraction: Attraction! {
        didSet {
            nameLabel.text = attraction.name
            addressLabel.text = "􀋕 \(attraction.newAddr ?? "주소 불명")"
            telLabel.text = "􀒥 \(attraction.tel)"
            descriptionLabel.text = attraction.intro
        }
    }
    
    let nameLabel = {
        let label = UILabel()
        label.text = "관광지 이름"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    let addressLabel = {
        let label = UILabel()
        label.text = "􀋕 주소..."
        label.font = label.font.withSize(12)
        
        return label
    }()
    let telLabel = {
        let label = UILabel()
        label.text = "􀒥 전화번호..."
        label.font = label.font.withSize(12)
        
        return label
    }()
    
    let descriptionLabel = {
        let label = UILabel()
        label.text = "관광지 설명..."
        label.font = label.font.withSize(12)
        
        return label
    }()
    
    let imageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sheetPresentationController?.delegate = self
        sheetPresentationController?.selectedDetentIdentifier = .medium
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
        
        self.view.backgroundColor = .systemBackground
        setLayout()
    }
    
    private func setLayout() {
        [nameLabel, addressLabel, telLabel, imageView, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            telLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12),
            telLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 117),
            imageView.heightAnchor.constraint(equalToConstant: 127),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
}
