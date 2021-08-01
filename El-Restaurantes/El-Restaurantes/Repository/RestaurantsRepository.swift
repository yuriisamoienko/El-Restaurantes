//
//  RestaurantsRepository.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import UIKit

protocol RestaurantsRepositoryProtocol: AnyObject {
    
    func getAllrestaurants(completion: @escaping (Result<[RestaurantEntity], Error>) -> Void)
}

class RestaurantsRepository: NSObject, RestaurantsRepositoryProtocol {
    
    // MARK: Private Properties
    private let remoteRepository: RestaurantsRepositoryProtocol
    
    // MARK: Public Functions
    
    init(remoteRepository: RestaurantsRepositoryProtocol) {
        self.remoteRepository = remoteRepository
        super.init()
    }

    // MARK: RestaurantsRepositoryProtocol
    
    func getAllrestaurants(completion: @escaping (Result<[RestaurantEntity], Error>) -> Void) {
        remoteRepository.getAllrestaurants(completion: completion)
    }
    
}
