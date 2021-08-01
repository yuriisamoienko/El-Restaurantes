//
//  UINavigationControllerExt.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit

public extension UINavigationController {

    // MARK: Public Functions
    
    // extended 'pushViewController' with completion closure. 'completion' is called when pushing is done
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        if viewControllers.contains(viewController) {
            //app will crash if ut pushes the same view controller twice
            completion()
            return
        }
        DispatchQueue.main.async { [self] in
            self.pushViewController(viewController, animated: animated)
            guard animated == true, let coordinator = self.transitionCoordinator else {
                completion()
                return
            }
            coordinator.animate(alongsideTransition: nil) { [completion] _ in
                completion()
            }
        }
    }
    
    // extended 'popToViewController' with completion closure. 'completion' is called when poping is done
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        DispatchQueue.main.async { [self] in
            self.popToViewController(viewController, animated: animated)
            guard animated, let coordinator = self.transitionCoordinator else {
                DispatchQueue.main.async { completion() }
                return
            }
            coordinator.animate(alongsideTransition: nil) { _ in completion() }
        }
    }
    
    func hideNavigationBar() {
        isNavigationBarHidden = true
    }
    
    func showNavigationBar() {
        isNavigationBarHidden = false
    }
}
