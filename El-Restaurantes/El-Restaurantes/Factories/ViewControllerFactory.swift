//
//  ViewControllerFactory.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 02.08.2021.
//

import Foundation
import UIKit
import FoundationExtension

protocol ViewControllerFactoryProtocol {
    
    func createMapRestaurants() -> UIViewController
    func createListRestaurants() -> UIViewController
    func createRestaurantFullInfo(with: RestaurantEntity) -> UIViewController
}

final class ViewControllerFactory: ViewControllerFactoryProtocol {
    
    // MARK: Public Functions
    
    func createMapRestaurants() -> UIViewController {
        let result = MapRestaurantsVC()
        return result
    }
    
    func createListRestaurants() -> UIViewController {
        let result = ListRestaurantsVC()
        return result
    }
    
    func createRestaurantFullInfo(with entity: RestaurantEntity) -> UIViewController {
        let vc = RestaurantFullInfoVC()
        let presenter: RestaurantFullInfoPresenterProtocol = RestaurantFullInfoPresenter(view: vc, entity: entity)
        vc.presenter = presenter
        return vc
    }
}
