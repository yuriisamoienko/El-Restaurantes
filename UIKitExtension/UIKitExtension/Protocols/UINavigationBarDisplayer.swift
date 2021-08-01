//
//  UINavigationBarDisplayer.swift
//  UIKitExtension
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit

/*
 UINavigationBarDisplayer devoted to simplify show & hide navigation bar behaviour through the app
*/

public protocol UINavigationBarDisplayer: UIViewController {
    
    // vc must have this flag variables
    var navigationBarVisibility: NavigationBarVisibility { set get }
    var didAppearOnce: Bool { get }
    
}

public enum NavigationBarVisibility {
    case none
    case show
    case hide
}

public extension UINavigationBarDisplayer {
    
    // call it in 'viewWIllAppear'
    func showNavigationControllerBarIfNeeded() {
        switch navigationBarVisibility {
        case .hide:
            hideNavigationControllerBar()
            
        case .show:
            showNavigationControllerBar()
            
        default:
            break
        }
    }
    
}
