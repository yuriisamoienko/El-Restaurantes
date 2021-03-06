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
        let vc = MapRestaurantsVC()
        let presenter: MapRestaurantsPresenterProtocol = MapRestaurantsPresenter(view: vc)
        vc.presenter = presenter
        return vc
    }
    
    func createListRestaurants() -> UIViewController {
        let vc = ListRestaurantsVC()
        let presenter: ListRestaurantsPresenterProtocol = ListRestaurantsPresenter(view: vc)
        vc.presenter = presenter
        return vc
    }
    
    func createRestaurantFullInfo(with entity: RestaurantEntity) -> UIViewController {
        let vc = RestaurantFullInfoVC()
        let presenter: RestaurantFullInfoPresenterProtocol = RestaurantFullInfoPresenter(view: vc, entity: entity)
        vc.presenter = presenter
        return vc
    }
}
