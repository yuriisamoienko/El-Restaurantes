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
    
    private var annotations: [MKRestaurantAnnotation] = []
    
    // UI
    private let mapView = MKMapView()
    private let reloadButton = UIButton()
    
    // MARK: Dependency injection
    
    @Inject private var locationManager: LocationManagerProtocol
    @Inject private var restaurantsRepository: RestaurantsRepositoryProtocol
    @Inject private var appRouter: RootAppRouterProtocol

    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureMapView()
        configureReloadButton()
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
    
    private func configureReloadButton() {
        reloadButton.setBackgroundImage(.icons.arrowCounterclockwiseCircleFill, for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reloadButton)
        reloadButton.setWidthConstraint(constant: 50)
        reloadButton.setHeightConstraint(constant: 50)
        [
            reloadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ].activate()
    }
    
    @objc
    private func reloadData() {
        DispatchQueue.main.async {
            self.reloadButton.disable() // so user can't run reload again during reloading
            self.reloadButton.runRotateAnimation()
        }
        restaurantsRepository.getAllrestaurants { [unowned self] (result: Result<[RestaurantEntity], Error>) in
            DispatchQueue.main.async {
                self.reloadButton.layer.removeAllAnimations()
                self.reloadButton.enable()
            }
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
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
            self.mapView.fitAllAnnotations()
        }
    }
    
    private func removeAnnotationsFromMap() {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.annotations)
        }
    }
}


fileprivate extension UIView {
    
    @discardableResult
    func runRotateAnimation() -> CABasicAnimation {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
        return rotation
    }
}
