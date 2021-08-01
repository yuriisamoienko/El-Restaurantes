//
//  UILabel+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit

public extension UILabel {
    
    // MARK: Public Functions
    
    func textPixelWidth() -> CGFloat {
        let result = intrinsicContentSize.width
        return result
    }
    
}
