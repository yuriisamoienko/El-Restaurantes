//
//  NSDictionary+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension NSDictionary {
    
    // MARK: Public Properties
    
    func toDictionary() -> AnyDictionary {
        return self as Dictionary as AnyDictionary
    }
    
}
