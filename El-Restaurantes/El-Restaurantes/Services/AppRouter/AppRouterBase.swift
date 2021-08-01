//
//  AppRouterBase.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import Foundation
import UIKit
import FoundationExtension

open class AppRouterBase: NSObject, AppRouterProtocol, AppRouterImplementationProtocol {
    
    
    lazy var childRouters = [AppRouterProtocol]()

    open func showImplementation(item: AppRouterItem, animated: Bool, sender: Any, info: Any?, completion: @escaping () -> Void) -> Bool {
        fatalErrorEx("must be overriden in \(self.className())")
    }
    
    public func push(viewController closure: @escaping () -> UIViewController, from sender: Any, animated: Bool, completion: @escaping () -> Void) {
        let vc = closure()
        let navigationController = self.getNavigationController(from: sender)
        navigationController.pushViewController(vc, animated: animated, completion: {
            completion()
        })
    }
    
    private func getNavigationController(from item: Any) -> UINavigationController {
        var value: UINavigationController?
        if let result = item as? UINavigationController {
            value = result
        } else if let result = item as? UIViewController {
            value = result.navigationController
        } else if let result = item as? UIView {
            let parent = result.parentViewController
            value = parent as? UINavigationController ?? parent?.navigationController
        }
        guard let result = value else {
            fatalErrorEx("can't get UINavigationController from \(String(describing: item))")
        }
        return result
    }
    
    // MARK: AppRouterProtocol
    
    func showItem(_ item: AppRouterItem, animated: Bool, sender: Any, info: Any?, completion: @escaping () -> Void) -> Bool {
        var result = false
        if self.showImplementation(item: item, animated: animated, sender: sender, info: info, completion: {
            completion()
        }) == true {
            result = true
        } else {
            for router in self.childRouters {
                guard router.show(item: item, animated: animated, sender: sender, info: info, completion: {
                    completion()
                }) == true else {
                    continue
                }
                result = true
                break
            }
        }
        return result
    }
    
    func add(childRouter: AppRouterProtocol) -> Self {
        childRouters.append(childRouter)
        return self
    }
}

