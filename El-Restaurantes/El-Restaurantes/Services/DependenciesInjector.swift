//
//  DependenciesInjector.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 29.07.2021.
//

import Foundation
import FoundationExtension

/*
 Service for injection of all app services
 */

open class DependenciesInjector: NSObject, DependenciesInjectorProtocol {

    // MARK: Public Functions
    
    open func inject() {
        
        let locationManager: LocationManagerProtocol = LocationManager()
        add({ locationManager as LocationManagerProtocol })
        
        let restaurantsRepository: RestaurantsRepositoryProtocol = RestaurantsRepository(remoteRepository: RestaurantsRepositoryRemote())
        add({ restaurantsRepository as RestaurantsRepositoryProtocol })
        
        let viewControllerFactory: ViewControllerFactoryProtocol = ViewControllerFactory()
        add({ viewControllerFactory as ViewControllerFactoryProtocol })
        
        let appRouter: RootAppRouterProtocol = RootAppRouter()
        add({ appRouter as RootAppRouterProtocol })
        
    }
}
