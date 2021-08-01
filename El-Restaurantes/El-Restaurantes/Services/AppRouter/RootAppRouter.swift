//
//  RootAppRouter.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import Foundation
import UIKit

//for preventing injection of non-root Router as root, also it can have some unic funcs in future
protocol RootAppRouterProtocol: AppRouterProtocol {
    
    func getRootViewController() -> UIViewController
}

final class RootAppRouter: AppRouterBase, RootAppRouterProtocol {
    
    private let tabBarVC = MainTabBarController()
    
    override func showImplementation(item: AppRouterItem, animated: Bool, sender: Any, info: Any?, completion: @escaping () -> Void) -> Bool {
        var result = true
        
        switch item {
        case .mapRestaurants:
            tabBarVC.selectedTab = .mapRestaurants
            
        case .listRestaurants:
            tabBarVC.selectedTab = .listRestaurants
            
        case .restaurantFullInfo:
            if let topVC = UIApplication.topViewController(from: tabBarVC),
               let navigationVC = getNavigationController(from: topVC) {
                let vc = RestaurantFullInfoVC() //TODO factory
                
                let data = info as? RestaurantEntity ?? RestaurantEntity(id: 999, name: "European hotel", priceRange: 3, location: RestaurantEntity.Location(address: "Dilova St, 14А, Kyiv, 02000", latitude: 50.4560437, longtitude: 30.5337505))
                vc.name = data.name
                vc.address = data.location.address
                vc.price = data.priceRange
                vc.distance = 900
                vc.mapPointAnnotation = MKRestaurantAnnotation(entity: data)
                
                navigationVC.pushViewController(vc, animated: animated) {
                    completion()
                }
            } else {
                result = false
            }
            
        default:
            result = false
        }
        
        return result
    }
    
//    override func show(item: AppRouterItem, animated: Bool = true, sender: Any, info: Any? = nil, completion: @escaping () -> Void) -> Bool {
//        return super.show(item: item, animated: animated, sender: sender, info: info, completion: completion)
//    }

    // MARK: RootAppRouterProtocol
    
    func getRootViewController() -> UIViewController {
        return tabBarVC
    }
    
    // MARK: Private Functions
    
    private func getNavigationController(from vc: UIViewController) -> UINavigationController? {
        var result: UINavigationController?
        if let navigationController = vc.navigationController {
            result = navigationController
        } else if let navigationController = vc as? UINavigationController {
            result = navigationController
        }
        return result
    }
}

fileprivate extension UIApplication {
    
    class func topViewController(from controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(from: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(from: presented)
        }
        return controller
    }
    
}
