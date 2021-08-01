//
//  RestaurantsRepositoryProtocol.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import Foundation

/*
 Repository simplify access to data regardless it's root - from server or locale storage of any kind
 */

protocol RestaurantsRepositoryProtocol: AnyObject {
    
    func getAllrestaurants(completion: @escaping (Result<[RestaurantEntity], Error>) -> Void)
    
}
