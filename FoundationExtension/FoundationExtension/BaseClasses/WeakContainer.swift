//
//  WeakContainer.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 29.07.2021.
//

import Foundation

/*
 Allows store weak references as local variables, dictionary keys, array items etc.
 */

public class WeakContainer<T: AnyObject>: NSObject {
    
    // MARK: Public Properties
    
    public private(set) weak var content: T!
    
    // MARK: Private Properties
    
    private var onDeinit: ((T) -> Void)?
    
    // MARK: Public Functions
    
    public init(_ value: T, onDeinit: ((T) -> Void)? = nil) {
        self.content = value
        self.onDeinit = onDeinit
        super.init()
    }
    
    deinit {
        onDeinit?(content)
    }
}
