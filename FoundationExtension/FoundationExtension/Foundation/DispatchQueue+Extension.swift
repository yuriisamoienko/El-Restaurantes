//
//  DispatchQueue+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

public extension DispatchQueue {
    
    // MARK: Public Properties
    
    static var background: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
    
}
