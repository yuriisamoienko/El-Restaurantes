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

protocol MapRestaurantsVCProtocol: UIViewController {
    
    func set(centerCoordinate: CLLocationCoordinate2D)
    func onStartUpdating()
    func onStopUpdating()
    func set(annotations: [MKRestaurantAnnotation])
}

final class MapRestaurantsVC: UIViewControllerBase, MKMapViewDelegate, MapRestaurantsVCProtocol {
    
    // MARK: Public Properties
    
    public var presenter: MapRestaurantsPresenterProtocol?
    
    // MARK: Private Properties
    
    // UI
    private let mapView = MKMapView()
    private let reloadButton = UIButton()
    
    // MARK: Dependency injection
    
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
        super.viewDidAppear(animated)
        navigationController?.hideNavigationBar()
        
        presenter?.updateView(force: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: MapRestaurantsVCProtocol
    
    func set(centerCoordinate: CLLocationCoordinate2D) {
        self.mapView.centerCoordinate = centerCoordinate
    }
    
    
    func set(annotations: [MKRestaurantAnnotation]) {
        DispatchQueue.main.async { [unowned self] in
            self.mapView.removeAllAnotations()
            self.mapView.addAnnotations(annotations)
            self.mapView.fitAllAnnotations() //TODO fix console error: [VKDefault] Style Z is requested for an invisible rect
        }
    }
    
    func onStartUpdating() {
        DispatchQueue.main.async {
            self.reloadButton.disable() // so user can't run reload again during reloading
            self.reloadButton.runRotateAnimation()
        }
    }
    
    func onStopUpdating() {
        DispatchQueue.main.async {
            self.reloadButton.layer.removeAllAnimations()
            self.reloadButton.enable()
        }
    }

    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let entity = (view.annotation as? MKRestaurantAnnotation)?.entity else {
            fatalMistake("can't get entity")
            return
        }
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
        presenter?.updateView(force: true)
    }

}
