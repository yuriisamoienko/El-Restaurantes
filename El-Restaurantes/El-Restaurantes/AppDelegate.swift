//
//  AppDelegate.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Public Properties
    
    var window: UIWindow?
    
    // MARK: Private Properties
    private var dependenciesInjector: DependenciesInjectorProtocol = DependenciesInjector()
    
    @Inject private var appRouter: RootAppRouterProtocol

    // MARK: Public Functions
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = .appThemeBackground// .init(hexString: "0073FA")  // solid color
        
        UIBarButtonItem.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        UITabBar.appearance().barTintColor = .blue
//        UITabBar.appearance().tintColor = .white
        
        dependenciesInjector.inject()
        configureWindow()
        return true
    }

    // MARK: Private Functions
    
    private func configureWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        window.rootViewController = appRouter.getRootViewController()
        window.makeKeyAndVisible()
    }
}

