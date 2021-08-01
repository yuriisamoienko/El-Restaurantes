//
//  UIViewController+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit

public extension UIViewController {
    
    // MARK: Public Functions
    
    func present(viewController: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        if self.presentedViewController == viewController {
            return
        }
        // prevent crash when by mistake call from background thread
        DispatchQueue.main.async { [self, animated, completion] in
            self.present(viewController, animated: animated, completion: completion)
        }
    }
    
    func isVisible() -> Bool {
        var result = false
        if isViewLoaded == true,
           view.window != nil {
            result = true
        }
        return result
    }

    func hideNavigationControllerBar() {
        navigationController?.hideNavigationBar()
    }
    
    func showNavigationControllerBar() {
        navigationController?.showNavigationBar()
    }
}
