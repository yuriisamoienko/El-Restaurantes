//
//  NSObject+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension NSObject {
    
    func className() -> String {
        let result = String(describing: type(of: self))
        return result
    }
    
}
