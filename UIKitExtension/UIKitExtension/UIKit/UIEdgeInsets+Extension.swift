//
//  UIEdgeInsets+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit

public extension UIEdgeInsets {
    
    func vertical() -> CGFloat {
        let result = top + bottom
        return result
    }

    func horizontal() -> CGFloat {
        let result = left + right
        return result
    }
    
    static func make(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self  {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
    
}
