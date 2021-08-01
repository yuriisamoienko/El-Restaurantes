//
//  ViewControllerFactory.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 02.08.2021.
//

import Foundation
import UIKit
import FoundationExtension

protocol ViewControllerFactoryProtocol {
    
    func createMapRestaurants() -> UIViewController
}

final class ViewControllerFactory: ViewControllerFactoryProtocol {
    
    // MARK: Public Functions
    
    func createMapRestaurants() -> UIViewController {
        let result = MapRestaurantsVC()
        return result
    }
}
