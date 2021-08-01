//
//  UITableViewCellBase.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 31.07.2021.
//

import UIKit

class UITableViewCellBase: UITableViewCell {
    
    // MARK: Public Functions
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        postInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }
    
    //override it in subclass to make some additional initalization
    open func postInit() {
        
    }
}
