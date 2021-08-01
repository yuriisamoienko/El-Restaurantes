//
//  ListRestaurantsVC.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit
import CoreLocation
import FoundationExtension

final class ListRestaurantsVC: UITableViewControllerBase {
    
    // MARK: Private Properties
    
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
                self.itemLocationDict.removeAll()
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
    var itemLocationDict: [Int: Double] = [:]
    private func getDistance(from entity: RestaurantEntity, to userLocation: CLLocation) -> Double {
        if let result = itemLocationDict[entity.id] {
            return result
        }
        let data = entity.location
        let location = CLLocation(latitude: data.latitude, longitude: data.longtitude)
        let result = userLocation.distance(from: location)
        itemLocationDict[entity.id] = result
        return result
    }
    
    @Inject private var locationManager: LocationManagerProtocol
    @Inject private var restaurantsRepository: RestaurantsRepositoryProtocol
    @Inject private var appRouter: RootAppRouterProtocol

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let didAppearOnce = self.didAppearOnce
        super.viewDidAppear(animated)
        if didAppearOnce == false || dataList.isEmpty == true { // view appears for a first time
            reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func reloadData() {
        restaurantsRepository.getAllrestaurants { [unowned self] (result: Result<[RestaurantEntity], Error>) in
            switch result {
            case .success(let list):
                self.dataList = list
                
            case .failure(let error):
                alert.showErrorAlert(error: error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
        cell.distance = itemLocationDict[item.id] ?? 0
//        cell.backgroundColor = view.backgroundColor

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
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Private Functions
    
    private func configureView() {
//        view.backgroundColor = .purple
        navigationBarVisibility = .hide
        
        tableView.registerCellForReuse(ListRestaurantTableViewCell.self)
    }
}
