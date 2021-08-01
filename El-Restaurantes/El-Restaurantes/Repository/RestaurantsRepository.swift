//
//  RestaurantsRepository.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import UIKit

/*
 Implementation of Respository for fetching restaurants data.
 It handles both remote and local (future feature) repositories
 */

final class RestaurantsRepository: NSObject, RestaurantsRepositoryProtocol {
    
    // MARK: Private Properties
    
    private let remoteRepository: RestaurantsRepositoryProtocol
    
    // MARK: Public Functions
    
    init(remoteRepository: RestaurantsRepositoryProtocol) {
        self.remoteRepository = remoteRepository
        super.init()
    }

    // MARK: RestaurantsRepositoryProtocol
    
    func getAllrestaurants(completion: @escaping (Result<[RestaurantEntity], Error>) -> Void) {
        // try get from remote repository
        remoteRepository.getAllrestaurants(completion: completion)
    }
    
}
