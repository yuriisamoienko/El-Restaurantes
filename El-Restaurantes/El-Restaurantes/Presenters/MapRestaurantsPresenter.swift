//
//  MapRestaurantsPresenter.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 02.08.2021.
//

import UIKit
import FoundationExtension

protocol MapRestaurantsPresenterProtocol {
    
    init(view: MapRestaurantsVCProtocol)
    
    func updateView(force: Bool)
    
}

final class MapRestaurantsPresenter: NSObject, MapRestaurantsPresenterProtocol {

    // MARK: Private Properties
    
    private var view: MapRestaurantsVCProtocol
    private var annotations: [MKRestaurantAnnotation] = []
    
    // MARK: Dependency injection
    
    @Inject private var locationManager: LocationManagerProtocol
    @Inject private var restaurantsRepository: RestaurantsRepositoryProtocol
    
    // MARK: ListRestaurantsPresenterProtocol

    init(view: MapRestaurantsVCProtocol) {
        self.view = view
        super.init()
    }
    
    deinit {
        locationManager.remove(observer: self)
    }
    
    func updateView(force: Bool) {
        if force == false {
            locationManager.requestLocation(from: view) { _ in
                
                self.locationManager.getLocation { [unowned self] result in
                    switch result {
                    case .success(let location):
                        printFuncLog("location: \(location)")
                        self.view.set(centerCoordinate: location.coordinate)
                    
                    case .failure(let error):
                        printFuncLog(error: error)
                    }
                }
            }
        }
        if force == true || annotations.isEmpty == true {
            reloadData()
        }
    }

    // MARK: Private Functions
    
    private func reloadData() {
        view.onStartUpdating()
        
        restaurantsRepository.getAllrestaurants { [unowned self] (result: Result<[RestaurantEntity], Error>) in
            view.onStopUpdating()
            
            switch result {
            case .success(let list):
                self.annotations.removeAll()
                for item in list {
                    let annotation = MKRestaurantAnnotation(entity: item)
                    
                    self.annotations.append(annotation)
                }
                view.set(annotations: self.annotations)
                
            case .failure(let error):
                view.alert.showErrorAlert(error: error)
            }
        }
    }
}
