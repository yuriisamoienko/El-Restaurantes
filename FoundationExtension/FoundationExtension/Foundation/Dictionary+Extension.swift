//
//  Dictionary+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension Dictionary {
    
    // MARK: Public Functions
    
    func toData() throws -> Data {
        let result = try JSONSerialization.data(
            withJSONObject: self,
            options: []
        )
        return result
    }

    func int(forKey key: Key?) -> Int? {
        var result: Int?
        if let key = key {
            if let data = self[key] {
                if let value = data as? Int {
                    result = value
                } else if let str = data as? String,
                    let value = Int(str) {
                    result = value
                }
            }
        }
        return result
    }
    
    func double(forKey key: Key?) -> Double? {
        var result: Double?
        if let key = key {
            if let data = self[key] {
                if let value = data as? Double {
                    result = value
                } else if let str = data as? String,
                    let value = Double(str) {
                    result = value
                } else if let value = data as? Int {
                    result = Double(value)
                } else if let value = data as? Bool {
                    result = value ? 1: 0
                }
            }
        }
        return result
    }
    
}
