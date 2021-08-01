//
//  AppRouterProtocol.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import Foundation

// enum contains all views, view controllers etc. which can be shown
//item can be ViewContoller, View, Screen etc.
public enum AppRouterItem {
    case mapRestaurants
    case listRestaurants
    case restaurantFullInfo
}

protocol AppRouterProtocol {
    
    //return true if coordinator can show the item and did it, else return false
    //completion is called when showing is done, for example after viewController appeared on screen
    func show(item: AppRouterItem, animated: Bool, sender: Any, info: Any?, completion: @escaping () -> Void) -> Bool
    
    //for making compositions of sub coordinators
    @discardableResult
    func add(childRouter: AppRouterProtocol) -> Self
}

extension AppRouterProtocol {
    
    @discardableResult
    func show(item: AppRouterItem, animated: Bool = true, sender: Any, info: Any? = nil, completion: @escaping () -> Void = {}) -> Bool {
        var result = false
        if let router = self as? AppRouterImplementationProtocol {
            result = router.showItem(item, animated: animated, sender: sender, info: info, completion: completion)
        }
        return result
    }
}

protocol AppRouterImplementationProtocol {
    
    func showItem(_ item: AppRouterItem, animated: Bool, sender: Any, info: Any?, completion: @escaping () -> Void) -> Bool
    
}
