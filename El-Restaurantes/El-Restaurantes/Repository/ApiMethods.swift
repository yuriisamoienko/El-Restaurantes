//
//  ApiMethods.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import Foundation

final class ApiMethods {
    
    // MARK: Private Properties
    
    private let host = "https://cms.dgrp.cz/ios"
    
    // MARK: Public Properties
    
    static var shared = ApiMethods()
    
    var getAllRestaurants: String {
        let result = "\(host)/data.json"
        return result
    }
}
