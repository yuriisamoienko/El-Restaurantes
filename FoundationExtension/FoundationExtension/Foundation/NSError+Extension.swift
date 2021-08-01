//
//  NSError+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension NSError {
    
    var message: String? {
        get {
            let result = userInfo[NSLocalizedDescriptionKey] as? String
            return result
        }
    }
    
    convenience init(code: Int = 0, message: String) {
        self.init(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    convenience init(message: String) {
        self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    convenience init(code: Int, userInfo: [String: Any]? = nil) {
        self.init(domain: "", code: 0, userInfo: userInfo)
    }
    
    convenience init(userInfo: [String: Any]? = nil) {
        self.init(code: 0, userInfo: userInfo)
    }
    
}
