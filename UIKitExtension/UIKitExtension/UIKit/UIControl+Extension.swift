//
//  UIControl+Extension.swift
//  UIKitExtension
//
//  Created by Yurii Samoienko on 02.08.2021.
//

import UIKit

public extension UIControl {
    
    // MARK: Public Functions
    
    @discardableResult
    func disable() -> Self {
        isEnabled = false
        return self
    }

    @discardableResult
    func enable() -> Self {
        isEnabled = true
        return self
    }

}
