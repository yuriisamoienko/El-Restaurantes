//
//  MainTabBarController.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit

/*
 Main bottom tab bar
 */

final class MainTabBarController: UITabBarController {
    
    // MARK: Types
    
    enum Tab: Int {
        case mapRestaurants
        case listRestaurants
    }
    
    // MARK: Public Properties
    
    public var selectedTab: Tab {
        set {
            selectedIndex = newValue.rawValue
        }
        get {
            let result = Tab(rawValue: selectedIndex) ?? .mapRestaurants
            return result
        }
    }
    
    // MARK: Private Properties
    
    private var tabViewControllers: [UIViewController] = [] {
        didSet {
            viewControllers = tabViewControllers
        }
    }

    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackgroundColor
        
        configureTabs()
    }

    // MARK: Private Functions
    
    private func configureTabs() {
        let mapVC = MapRestaurantsVC() //TODO factory
        let listVC = ListRestaurantsVC()
        
        addTab(mapVC) { tabBar in
            tabBar.image = .icons.mapFill
            tabBar.title = .localize.map.capitalized
        }
        addTab(listVC) { tabBar in
            tabBar.image = .icons.playlistAddCheck
            tabBar.title = .localize.list.capitalized
        }
        
    }
    
    // add tab vc and wrap it into UINavigationController
    // use 'configure' to setup tab icon and title
    private func addTab(_ vc: UIViewController, configure: @escaping (UIBarItem) -> Void) {
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.hideNavigationBar()
        
        let tabVC = navigationVC
        tabViewControllers.append(tabVC)
        configure(tabVC.tabBarItem)
    }
}
