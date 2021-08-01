//
//  UIStackView+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import UIKit

public extension UIStackView {
    
    // MARK: Init
    
    convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
    }
    
    // MARK: Public Functions
    
    func addArrangedSubviews(_ views: UIView?...) {
        let items: [UIView?] = views
        addArrangedSubviews(items)
    }
    
    func addArrangedSubviews(_ views: [UIView?]) {
        for item in views {
            if let view = item {
                addArrangedSubview(view)
            }
        }
    }
    
}

