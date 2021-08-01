//
//  Array+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension Array {
    
    func element(at index: Int) -> Element? {
        guard index >= 0,
              index < self.count
        else {
            return nil
        }
        return self[index]
    }
    
}
