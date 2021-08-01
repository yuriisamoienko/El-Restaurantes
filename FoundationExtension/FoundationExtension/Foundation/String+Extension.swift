//
//  String+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension String {
    
    // MARK: Public Functions
    
    // check if string has one of prefixes
    func hasOnePrefix(_ prefixes: [String]) -> Bool {
        var result = false
        for prefix in prefixes {
            if self.hasPrefix(prefix) == true {
                result = true
                break
            }
        }
        return result
    }
    
    func substring(to index: Int) -> Self {
        let result = (self as NSString).substring(to: index)
        return result
    }
    
    func substring(from index: Int) -> Self {
        let result = (self as NSString).substring(from: index)
        return result
    }
    
}
