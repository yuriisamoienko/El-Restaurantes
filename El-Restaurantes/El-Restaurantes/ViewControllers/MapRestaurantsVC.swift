//
//  MapRestaurantsVC.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit
import MapKit
import FoundationExtension

/*
 A mapView with fetched restaurants.
 User can select a restaurant on map to open Details screen
 */

final class MapRestaurantsVC: UIViewControllerBase, MKMapViewDelegate {
    
    // MARK: Private Properties
    
    private let mapView = MKMapView()
    private var annotations: [MKRestaurantAnnotation] = []
    
    // MARK: Dependency injection
    
    @Inject private var locationManager: LocationManagerProtocol
    @Inject private var restaurantsRepository: RestaurantsRepositoryProtocol
    @Inject private var appRouter: RootAppRouterProtocol

    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let didAppearOnce = self.didAppearOnce
        super.viewDidAppear(animated)
        navigationController?.hideNavigationBar()
        if didAppearOnce == false {
            locationManager.requestLocation(from: self) { _ in
                
                self.locationManager.getLocation { [unowned self] result in
                    switch result {
                    case .success(let location):
                        printFuncLog("location: \(location)")
                        self.mapView.centerCoordinate = location.coordinate
                    
                    case .failure(let error):
                        printFuncLog(error: error)
                    }
                }
            }
        }
        if didAppearOnce == false || annotations.isEmpty == true {
            reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        locationManager.remove(observer: self)
    }

    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let entity = (view.annotation as? MKRestaurantAnnotation)?.entity
        self.appRouter.show(item: .restaurantFullInfo, sender: self, info: entity)
    }

    // MARK: Private Functions
    
    private func configureView() {
        view.backgroundColor = .systemBackgroundColor
        navigationBarVisibility = .hide
    }
    
    private func configureMapView() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.delegate = self
        self.view.addSubview(mapView)
        mapView.pinEdges(to: view)
    }
    
    private func reloadData() {
        restaurantsRepository.getAllrestaurants { [unowned self] (result: Result<[RestaurantEntity], Error>) in
            switch result {
            case .success(let list):
                self.removeAnnotationsFromMap()
                for item in list {
                    let annotation = MKRestaurantAnnotation(entity: item)
                    
                    self.annotations.append(annotation)
                }
                self.putAnnotationsOnMap()
                
            case .failure(let error):
                alert.showErrorAlert(error: error)
            }
        }
    }
    
    private func putAnnotationsOnMap() {
        mapView.addAnnotations(annotations)
        DispatchQueue.main.async {
            self.mapView.fitAllAnnotations()
        }
    }
    
    private func removeAnnotationsFromMap() {
        mapView.removeAnnotations(annotations)
    }
}

