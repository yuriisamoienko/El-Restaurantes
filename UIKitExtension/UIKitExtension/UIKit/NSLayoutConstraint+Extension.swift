//
//  NSLayoutConstraint+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import UIKit

public extension NSLayoutConstraint {
    
    func activate() {
        isActive = true
    }
    
    func activated() -> Self {
        isActive = true
        return self
    }

}

public extension Array where Element: NSLayoutConstraint {
    
    func activate() {
        forEach {
            $0.activate()
        }
    }
    
}
