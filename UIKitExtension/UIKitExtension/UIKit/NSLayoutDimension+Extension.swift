//
//  NSLayoutDimension+Extension.swift
//  UIKitExtension
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit

public extension NSLayoutDimension {
    
    func constraint(constant: CGFloat, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .greaterThanOrEqual:
            constraint = self.constraint(greaterThanOrEqualToConstant: constant)
            
        case .lessThanOrEqual:
            constraint = self.constraint(lessThanOrEqualToConstant: constant)
            
        default:
            constraint = self.constraint(equalToConstant: constant)
        }
        return constraint
    }
    
}
