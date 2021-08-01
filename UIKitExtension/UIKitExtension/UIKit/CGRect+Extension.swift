//
//  CGRect+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit

public extension CGRect {
    
    var center: CGPoint {
        var result = self.origin
        result.x += self.size.width/2
        result.y += self.size.height/2
        return result
    }
    
}
