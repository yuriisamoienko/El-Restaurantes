//
//  RestaurantFullInfoVC.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit
import MapKit
import FoundationExtension

/*
 Restaurant details screen:
 - name
 - address
 - price range
 - location on map
 */

final class RestaurantFullInfoVC: UIViewControllerBase {
    
    // MARK: Public Properties
    
    public var name: String = "" {
        didSet {
            onNameDidSet()
        }
    }
    public var price: Int = 0 {
        didSet {
            onPriceDidSet()
        }
    }
    public var address: String = "" {
        didSet {
            onAddressDidSet()
        }
    }
    public var distance: Double = 0 {
        didSet {
            onDistanceDidSet()
        }
    }
    public var mapPointAnnotation: MKAnnotation?
    
    // MARK: Private Properties
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let addressLabel = UILabel()
    private let distanceLabel = UILabel()
    private let mapView = MKMapView()
    private let mapLoadingSpinner = UIActivityIndicatorView(style: .gray)
    private let mapLoadingSpinnerContainer = UIView()
    
    // MARK: Overriden functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.title = .localize.details.capitalized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let didAppearOnce = self.didAppearOnce
        super.viewDidAppear(animated)

        if didAppearOnce == false,
           let annotation = mapPointAnnotation {
            mapView.addAnnotation(annotation)
            mapView.setCenter(coordinate: annotation.coordinate, zoomLevel: 15, animated: false)

            // map doesn't show the annotaion immediately, so let's show loading animation to avoid jumping of map region
            debounce(delay: 0.5) { [unowned self] in
                self.mapLoadingSpinnerContainer.hide()
                self.mapLoadingSpinner.stopAnimating()
            }
        }
    }
    
    // MARK: Private Functions

    private func onNameDidSet() {
        nameLabel.text = name
    }
    
    private func onPriceDidSet() {
        priceLabel.text = String(repeating: "$", count: price)
    }
    
    private func onAddressDidSet() {
        addressLabel.text = address
    }
    
    private func onDistanceDidSet() {
        // need format distance
        let df = MKDistanceFormatter()
        df.unitStyle = .abbreviated
        df.units = .metric
        let prettyString = df.string(fromDistance: distance) // formated distance in m or km
        distanceLabel.text = prettyString
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackgroundColor
        navigationBarVisibility = .show
        
        nameLabel.font = .systemFont(ofSize: 26)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .center
        priceLabel.textColor = .systemGreen

        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .systemGray
        addressLabel.textAlignment = .center
        addressLabel.setHeightConstraint(constant: 15, relatedBy: .greaterThanOrEqual)
        
        distanceLabel.textAlignment = .right
        distanceLabel.font = .systemFont(ofSize: 12)
        
        mapView.showsUserLocation = false
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        
        mapLoadingSpinner.color = .appThemeBackground
        mapLoadingSpinner.startAnimating()
        mapLoadingSpinnerContainer.addSubview(mapLoadingSpinner)
        mapLoadingSpinnerContainer.backgroundColor = .systemBackgroundColor
        mapLoadingSpinner.centerInSuperview()
        mapLoadingSpinner.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        let scaleSpinner: CGFloat = 2
        mapLoadingSpinner.transform = .init(scaleX: scaleSpinner, y: scaleSpinner)
        mapView.addSubview(mapLoadingSpinnerContainer)
        mapLoadingSpinnerContainer.pinEdges(to: mapView)
        
        mapView.setHeightConstraint(constant: 0, relatedBy: .greaterThanOrEqual)
        mapView.borderWidth = 1
        mapView.borderColor = .appThemeBackground
        mapView.cornerRadius = 20
        
        let contentStackView = UIStackView(axis: .vertical)
        contentStackView.spacing = 10
        contentStackView.addArrangedSubviews(
            nameLabel,
            priceLabel,
            addressLabel,
            mapView
        )
        self.view.addSubview(contentStackView)
        contentStackView.pinEdges(to: view.layoutMarginsGuide, spacingHorizontal: 0, spacingVertical: 10)
    }
    
}
