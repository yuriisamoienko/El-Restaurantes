//
//  MainTabBarController.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    enum Tab: Int {
        case mapRestaurants
        case listRestaurants
    }
    
    public var selectedTab: Tab {
        set {
            selectedIndex = newValue.rawValue
        }
        get {
            let result = Tab(rawValue: selectedIndex) ?? .mapRestaurants
            return result
        }
    }
    
    private var tabViewControllers: [UIViewController] = [] {
        didSet {
            viewControllers = tabViewControllers
        }
    }

    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if #available(iOS 13.0, *) {
//            view.backgroundColor = .systemBackground
//        } else {
//            view.backgroundColor = .white
//        }
        view.backgroundColor = .systemBackgroundColor
        
        configureTabs()
    }

    // MARK: Private Functions
    
    private func configureTabs() {
        let mapVC = MapRestaurantsVC()
       
        
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
    
    private func addTab(_ vc: UIViewController, configure: @escaping (UIBarItem) -> Void) {
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.hideNavigationBar()
        
        let tabVC = navigationVC// vc
//        navigationVC.pushViewController(vc, animated: false)
        tabViewControllers.append(tabVC)
        configure(tabVC.tabBarItem)
    }
}
