//
//  RootAppRouter.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import Foundation
import FoundationExtension
import UIKit

//for preventing injection of non-root Router as root, also it can have some unic funcs in future
protocol RootAppRouterProtocol: AppRouterProtocol {
    
    func getRootViewController() -> UIViewController
}

final class RootAppRouter: AppRouterBase, RootAppRouterProtocol {
    
    // MARK: Private Properties
    
    private let tabBarVC = MainTabBarController()
    
    // MARK: Dependency injection
    @Inject private var viewControllerFactory: ViewControllerFactoryProtocol
    
    // MARK: Public Functions
    
    override func showImplementation(item: AppRouterItem, animated: Bool, sender: Any, info: Any?, completion: @escaping () -> Void) -> Bool {
        var result = true
        
        switch item {
        case .mapRestaurants:
            tabBarVC.selectedTab = .mapRestaurants
            
        case .listRestaurants:
            tabBarVC.selectedTab = .listRestaurants
            
        case .restaurantFullInfo:
            push(
                viewController: {
                    
                    let data = info as? RestaurantEntity ?? RestaurantEntity(id: 999, name: "European hotel", priceRange: 3, location: RestaurantEntity.Location(address: "Dilova St, 14А, Kyiv, 02000", latitude: 50.4560437, longtitude: 30.5337505))
                    let vc = self.viewControllerFactory.createRestaurantFullInfo(with: data)
                    
                    return vc
                },
                from: sender,
                animated: animated,
                completion: {
                    completion()
                }
            )
            
        default:
            result = false
        }
        
        return result
    }

    // MARK: RootAppRouterProtocol
    
    func getRootViewController() -> UIViewController {
        return tabBarVC
    }

}
