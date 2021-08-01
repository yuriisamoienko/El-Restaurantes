//
//  UIViewControllerBase.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit
import FoundationExtension
import UIKitExtension

class UIViewControllerBase: UIViewController, UINavigationBarDisplayer {
    
    // MARK: Public Properties
    
    internal private(set) var didAppearOnce = false
    var navigationBarVisibility: NavigationBarVisibility = .none

    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printFuncLog("class: \(self.className())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printFuncLog("class: \(self.className()), animated = \(animated)")
        
//        if didAppearOnce == false { // first appear
            showNavigationControllerBarIfNeeded()
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
//        let didAppearOnce = self.didAppearOnce
        super.viewDidAppear(animated)
        self.didAppearOnce = true
        printFuncLog("class: \(self.className()), animated = \(animated)")
        
//        if didAppearOnce == true { // non first appear
//            showNavigationControllerBarIfNeeded()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printFuncLog("class: \(self.className()), animated = \(animated)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printFuncLog("class: \(self.className()), animated = \(animated)")
    }

}

enum NavigationBarVisibility {
    case none
    case show
    case hide
}

protocol UINavigationBarDisplayer: UIViewController {
    
    // vc must have this flag variables
    var navigationBarVisibility: NavigationBarVisibility { set get }
    var didAppearOnce: Bool { get }
    
}

extension UINavigationBarDisplayer {
    
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
