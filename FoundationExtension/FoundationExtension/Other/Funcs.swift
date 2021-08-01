//
//  Funcs.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import Foundation

// dimplify delay of task
public func debounce(queue: DispatchQueue = .main, delay: Double, closure: @escaping() -> Void) {
    queue.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
