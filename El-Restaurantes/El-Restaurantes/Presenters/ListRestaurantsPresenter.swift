//
//  ListRestaurantsPresenter.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 02.08.2021.
//

import UIKit
import CoreLocation
import FoundationExtension

protocol ListRestaurantsPresenterProtocol {
    
    init(view: ListRestaurantsVcProtocol)
    
    func updateView(force: Bool)
    func getDataList() -> [RestaurantEntity]
    func getDistanceTo(id: Int) -> Double
}

final class ListRestaurantsPresenter: NSObject, ListRestaurantsPresenterProtocol {

    // MARK: Private Properties
    
    private var view: ListRestaurantsVcProtocol

    // sorted from nearest
    private var _dataList: [RestaurantEntity] = [] {
        didSet {
            view.reloadList()
        }
    }
    private var dataList: [RestaurantEntity] {
        set {
            self.locationManager.getLocation { [unowned self] locationResult in
                self.itemDistanceDict.removeAll()
                switch locationResult {
                case .failure(let error):
                    printFuncLog(error: error)
                    self._dataList = newValue
                
                case .success(let userLocation):
                    self._dataList = newValue.sorted(by: { lhs, rhs in
                        let leftDistance = self.getDistance(from: lhs, to: userLocation)
                        let rightDistance = self.getDistance(from: rhs, to: userLocation)
                        return leftDistance < rightDistance
                    })
                }
            }
        }
        get {
            return _dataList
        }
    }
    private var itemDistanceDict: [Int: Double] = [:]
    
    private func getDistance(from entity: RestaurantEntity, to userLocation: CLLocation) -> Double {
        if let result = itemDistanceDict[entity.id] {
            return result
        }
        let data = entity.location
        let location = CLLocation(latitude: data.latitude, longitude: data.longtitude)
        let result = userLocation.distance(from: location)
        itemDistanceDict[entity.id] = result
        return result
    }
    
    // MARK: Dependency injection
    
    @Inject private var locationManager: LocationManagerProtocol
    @Inject private var restaurantsRepository: RestaurantsRepositoryProtocol
    
    // MARK: ListRestaurantsPresenterProtocol

    init(view: ListRestaurantsVcProtocol) {
        self.view = view
        super.init()
    }
    
    func updateView(force: Bool) {
        if force || dataList.isEmpty == true {
            reloadData()
        }
    }
    
    func getDataList() -> [RestaurantEntity] {
        return dataList
    }
    
    func getDistanceTo(id: Int) -> Double {
        let result = itemDistanceDict[id] ?? 0
        return result
    }
    
    // MARK: Private Functions
    
    private func reloadData() {
        restaurantsRepository.getAllrestaurants { [unowned self] (result: Result<[RestaurantEntity], Error>) in
            self.view.endUpdating()
            
            switch result {
            case .success(let list):
                self.dataList = list
                
            case .failure(let error):
                view.alert.showErrorAlert(error: error)
            }
        }
    }
}
