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

protocol ListRestaurantsVcProtocol: UIViewController {
    
    func reloadList()
    func endUpdating()
}

final class ListRestaurantsVC: UITableViewControllerBase, ListRestaurantsVcProtocol {
    
    // MARK: Public Properties
    
    public var presenter: ListRestaurantsPresenterProtocol?
    
    // MARK: Private Properties
    
    // MARK: Dependency injection
    
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
        super.viewDidAppear(animated)
        
        presenter?.updateView(force: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: ListRestaurantsVcProtocol
    
    func reloadList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func endUpdating() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // we need only one section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = presenter?.getDataList().count ?? 0
        return result
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let item = presenter?.getDataList().element(at: row) else {
            fatalMistake("can't get item at row \(row)")
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(byType: ListRestaurantTableViewCell.self, forIndexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.name = item.name
        cell.price = item.priceRange
        cell.address = item.location.address
        cell.distance = presenter?.getDistanceTo(id: item.id) ?? 0

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let item = presenter?.getDataList().element(at: row) else {
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: .localize.pullToRefresh.capitalized)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        self.refreshControl = refreshControl
    }
    
    @objc
    private func refresh(_ sender: AnyObject) {
        // it feels not working without delay
        debounce(queue: .background, delay: 1.0) { [unowned self] in
            self.presenter?.updateView(force: true)
        }
        
    }
    
}
