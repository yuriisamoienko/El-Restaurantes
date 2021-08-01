//
//  String+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension String {
    
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
    
}
