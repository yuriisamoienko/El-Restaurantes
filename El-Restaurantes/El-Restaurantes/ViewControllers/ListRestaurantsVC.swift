//
//  ListRestaurantsVC.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit
import CoreLocation
import FoundationExtension

/*
 A list of fetched restaurants (from the nearest).
 */

final class ListRestaurantsVC: UITableViewControllerBase {
    
    // MARK: Private Properties
    
    // sorted from nearest
    private var _dataList: [RestaurantEntity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var dataList: [RestaurantEntity] {
        set {
            self.locationManager.getLocation { [unowned self] locationResult in
                self.itemDistanceDict.removeAll()
                switch locationResult {
                case .failure(let error):
                    self.alert.showErrorAlert(error: error)
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
    @Inject private var appRouter: RootAppRouterProtocol

    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let didAppearOnce = self.didAppearOnce
        super.viewDidAppear(animated)
        if didAppearOnce == false || dataList.isEmpty == true {
            reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // we need only one section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = dataList.count
        return result
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let item = self.dataList.element(at: row) else {
            fatalMistake("can't get item at row \(row)")
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(byType: ListRestaurantTableViewCell.self, forIndexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.name = item.name
        cell.price = item.priceRange
        cell.address = item.location.address
        cell.distance = itemDistanceDict[item.id] ?? 0

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let item = self.dataList.element(at: row) else {
            fatalMistake("can't get item at row \(row)")
            return
        }
        self.appRouter.show(item: .restaurantFullInfo, sender: self, info: item)
    }

    // MARK: Private Functions
    
    private func configureView() {
        view.backgroundColor = .systemBackgroundColor
        navigationBarVisibility = .hide
        
        tableView.registerCellForReuse(ListRestaurantTableViewCell.self)
    }
    
    private func reloadData() {
        restaurantsRepository.getAllrestaurants { [unowned self] (result: Result<[RestaurantEntity], Error>) in
            switch result {
            case .success(let list):
                self.dataList = list
                
            case .failure(let error):
                //alert.showErrorAlert(error: error)
                printFuncLog(error: error)
            }
        }
    }
    
}
