//
//  UIImageView+.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/03/19.
//

import UIKit

extension UIImageView {
    static func ofSystemImage(systemName: String, fontSize: CGFloat, weight: UIImage.SymbolWeight = .regular) -> UIImageView {
        let image = UIImage(systemName: systemName)
        let configuration = UIImage.SymbolConfiguration(pointSize: fontSize, weight: weight)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.preferredSymbolConfiguration = configuration
        
        return imageView
    }
}
