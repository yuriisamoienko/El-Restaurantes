//
//  RestaurantsRepositoryRemote.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import FoundationExtension
import UIKit

final class RestaurantsRepositoryRemote: NSObject, RestaurantsRepositoryProtocol {

    // MARK: RestaurantsRepositoryProtocol
    
    // get list of all restaurants
    func getAllrestaurants(completion: @escaping (Result<[RestaurantEntity], Error>) -> Void) {
        let url = ApiMethods.shared.getAllRestaurants
        printFuncLog("url = \(url)")
        
        // run request
        URLSession.standart.runDefaultDataTask(with: url) { data, response, error in
            let onFailure: (Error) -> Void = { error in
                completion(.failure(error))
            }
            let onFailureMessage: (String) -> Void = { message in
                let error = NSError(message: message)
                onFailure(error)
            }
            if let error = error {
                onFailure(error)
                return
            }
            guard let data = data else {
                onFailureMessage("data is nil")
                return
            }
            do {
                // validate response
                guard let json = try data.decodeToAny() as? [String: Any] else {
                    onFailureMessage("data is not a json")
                    return
                }
                guard let restaurantsData = json["restaurants"] else {
                    onFailureMessage("restaurants key is missed")
                    return
                }
                guard let restaurants = restaurantsData as? [[String: Any]] else {
                    onFailureMessage("restaurants value is not a json array")
                    return
                }
                let restaurantJsonArray: [[String: Any]] = restaurants.map {
                    $0["restaurant"] as? [String: Any] ?? [String: Any]()
                }
                // decode result
                let result = try [RestaurantEntity].decode(from: restaurantJsonArray)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
