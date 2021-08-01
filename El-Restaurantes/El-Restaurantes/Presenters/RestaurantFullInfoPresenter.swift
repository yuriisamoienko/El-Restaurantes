//
//  RestaurantFullInfoPresenter.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 02.08.2021.
//

import UIKit

protocol RestaurantFullInfoPresenterProtocol {
    
    init(view: RestaurantFullInfoVcProtocol, entity: RestaurantEntity)
    func updateView()
}

final class RestaurantFullInfoPresenter: NSObject, RestaurantFullInfoPresenterProtocol {

    // MARK: Private Properties
    
    private var entity: RestaurantEntity
    private var view: RestaurantFullInfoVcProtocol

    // MARK: RestaurantFullInfoPresenterProtocol

    init(view: RestaurantFullInfoVcProtocol, entity: RestaurantEntity) {
        self.entity = entity
        self.view = view
        super.init()
    }
    
    func updateView() {
        view.name = entity.name
        view.address = entity.location.address
        view.price = entity.priceRange
        view.mapPointAnnotation = MKRestaurantAnnotation(entity: entity)
    }
}
