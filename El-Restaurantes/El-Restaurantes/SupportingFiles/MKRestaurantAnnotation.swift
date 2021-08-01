//
//  MKRestaurantAnnotation.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import Foundation
import MapKit

final class MKRestaurantAnnotation: MKPointAnnotation {
    
    let entity: RestaurantEntity
    
    init(entity: RestaurantEntity) {
        self.entity = entity
        super.init()
        title = entity.name
        subtitle = entity.location.address
        let location = entity.location
        coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longtitude)
    }
    
}
