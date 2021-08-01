//
//  DependenciesInjection.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 29.07.2021.
//

import Foundation

/*
 DependenciesInjector is a service for injection of all app services
 */

public protocol DependenciesInjectorProtocol {
    
    func inject()
    
}

public extension DependenciesInjectorProtocol {
    
    func add<T>(_ factory: @escaping () -> T) {
        Dependencies.root.add(factory)
    }
    
}

fileprivate class Dependencies {

    // MARK: Private Properties
    
    static fileprivate var root: Dependencies = {
        let instance = Dependencies()
        return instance
    }()
    private var factories = [String: () -> Any]()

    // MARK: Functions
    
    func add<T>(_ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        factories[key] = factory
    }
    
    func resolve<T>() -> T {
        let key = String(describing: T.self)

        guard let component: T = factories[key]?() as? T else {
            fatalErrorEx("Dependency '\(T.self)' not resolved!")
        }

        return component
    }
    
    private init() {}
}

@propertyWrapper
public struct Inject<Value> {

    // MARK: Public Properties
    
    public var wrappedValue: Value {
        Dependencies.root.resolve()
    }

    // MARK: Public Functions
    
    public init() {}
}

/* EXAMPLE
 
 open class DependenciesInjector: NSObject, DependenciesInjectorProtocol {

     open func inject() {
         let viewControllerFactory: ViewControllerFactoryProtocol = ViewControllerFactory()
         add({ viewControllerFactory as ViewControllerFactoryProtocol })
         
         let appRouter: AppRouterProtocol = AppRouter()
         add({ appRouter as AppRouterProtocol })
         
         let coreLogic: CoreLogicProtocol = CoreLogic()
         add({ coreLogic as CoreLogicProtocol })
         
         //crash and non fatal errors reporting
         let crashReporter: CrashReporterProtocol = FirebaseCrashlyticsFacade()
         add({ crashReporter as CrashReporterProtocol })
     }
 }

 
 */
