//
//  RestaurantFullInfoVC.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit
import MapKit
import FoundationExtension

final class RestaurantFullInfoVC: UIViewControllerBase {
    
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
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let addressLabel = UILabel()
    private let distanceLabel = UILabel()
    private let mapView = MKMapView()
    private let mapLoadingSpinner = UIActivityIndicatorView(style: .gray)
    private let mapLoadingSpinnerContainer = UIView()
//    private lazy var distanceLabelWidthConstraint = distanceLabel.setWidthConstraint(constant: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.title = "Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let didAppearOnce = self.didAppearOnce
        super.viewDidAppear(animated)
//        navigationController?.showNavigationBar()
        
//        debounce(delay: 0.5) {
            
//        }
        if didAppearOnce == false,
           let annotation = mapPointAnnotation {
//            mapLoadingSpinner.showMe()
            mapView.addAnnotation(annotation)
//            mapView.setCenter(annotation.coordinate, animated: false)
//            mapView.fitAllAnnotations()
            mapView.setCenter(coordinate: annotation.coordinate, zoomLevel: 15, animated: false)
//            mapView.zoomLevel = 1
//            UIView.animate(withDuration: 0.1) {
//                self.mapView.alpha = 1
//            }
            debounce(delay: 0.5) { [unowned self] in
                self.mapLoadingSpinnerContainer.hide()
                self.mapLoadingSpinner.stopAnimating()
//                self.mapView.showMe()
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
        let df = MKDistanceFormatter()
        df.unitStyle = .abbreviated
        df.units = .metric
        let prettyString = df.string(fromDistance: distance)
        distanceLabel.text = prettyString
//        distanceLabelWidthConstraint.constant = distanceLabel.textPixelWidth()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackgroundColor
        navigationBarVisibility = .show
//        view.backgroundColor = .systemBlue
        
        nameLabel.font = .systemFont(ofSize: 26)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
//        nameLabel.setHeightConstraint(constant: 16, relatedBy: .greaterThanOrEqual)
//        nameLabel.backgroundColor = .yellow
//        nameLabel.setWidthConstraint(constant: 0, relatedBy: .greaterThanOrEqual)
        
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .center
//        priceLabel.backgroundColor = .green
//        priceLabel.numberOfLines = 0
//        priceLabel.setWidthConstraint(constant: 50)
        priceLabel.textColor = .systemGreen
        
//        let firstRowStackView = UIStackView(axis: .horizontal)
//        firstRowStackView.distribution = .fillProportionally
        
//        firstRowStackView.addArrangedSubviews(nameLabel, priceLabel)
//        firstRowStackView.setHeightConstraint(constant: 20, relatedBy: .greaterThanOrEqual)
        
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .systemGray
//        addressLabel.textAlignment = .left
        addressLabel.textAlignment = .center
        addressLabel.setHeightConstraint(constant: 15, relatedBy: .greaterThanOrEqual)
        
        distanceLabel.textAlignment = .right
        distanceLabel.font = .systemFont(ofSize: 12)
        
//        let secondRowStackView = UIStackView(axis: .horizontal)
//        secondRowStackView.addArrangedSubviews(addressLabel, distanceLabel)
//        secondRowStackView.spacing = 5
        
        mapView.showsUserLocation = false
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        
        mapLoadingSpinner.color = .appThemeBackground
        mapLoadingSpinner.startAnimating()
//        mapLoadingSpinner.hide()
        let scaleSpinner: CGFloat = 2
//
//        mapLoadingSpinnerContainer.setHeightConstraint(constant: 0, relatedBy: .greaterThanOrEqual)
        mapLoadingSpinnerContainer.addSubview(mapLoadingSpinner)
        mapLoadingSpinnerContainer.backgroundColor = .systemBackgroundColor
        
         mapLoadingSpinner.centerInSuperview()
        mapLoadingSpinner.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        mapLoadingSpinner.transform = .init(scaleX: scaleSpinner, y: scaleSpinner)
//        mapLoadingSpinner.setWidthConstraint(constant: 50)
//        mapLoadingSpinner.setHeightConstraint(constant: 50)
//        [
//            mapLoadingSpinner.centerXAnchor.constraint(equalTo: mapLoadingSpinnerContainer.centerXAnchor),
//            mapLoadingSpinner.centerYAnchor.constraint(equalTo: mapLoadingSpinnerContainer.centerYAnchor)
//        ].activate()
        mapView.addSubview(mapLoadingSpinnerContainer)
        mapLoadingSpinnerContainer.pinEdges(to: mapView)
//        mapLoadingSpinnerContainer.hide()
        
//        let mapViewStackView = UIStackView(axis: .vertical)
        mapView.setHeightConstraint(constant: 0, relatedBy: .greaterThanOrEqual)
        mapView.borderWidth = 1
        mapView.borderColor = .appThemeBackground
        mapView.cornerRadius = 20
//        mapViewStackView.addArrangedSubviews(
//            mapView,
//            mapLoadingSpinnerContainer
//        )
//        mapView.hide()
//        mapView.alpha = 0
        
        
        let contentStackView = UIStackView(axis: .vertical)
        contentStackView.spacing = 10
//        let spacingBottom = UIView(heightConstraintConstant: 0, relatedBy: .greaterThanOrEqual)
//        spacingBottom.backgroundColor = .green
        contentStackView.addArrangedSubviews(
            nameLabel,
            priceLabel,
            addressLabel,
            mapView
//            distanceLabel,
//            spacingBottom
        )
        self.view.addSubview(contentStackView)
        contentStackView.pinEdges(to: view.layoutMarginsGuide, spacingHorizontal: 0, spacingVertical: 10)
//        contentStackView.backgroundColor = .systemGreen
    }
}


extension MKMapView {
    
    func fitAllAnnotations(with padding: UIEdgeInsets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)) {
        var zoomRect: MKMapRect = .null
        annotations.forEach({
            let annotationPoint = MKMapPoint($0.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        })
        
        setVisibleMapRect(zoomRect, edgePadding: padding, animated: true)
    }
    
    func fit(annotations: [MKAnnotation], andShow show: Bool, with padding: UIEdgeInsets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)) {
        var zoomRect: MKMapRect = .null
        annotations.forEach({
            let aPoint = MKMapPoint($0.coordinate)
            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.isNull ? rect : zoomRect.union(rect)
        })
        
        if show {
            addAnnotations(annotations)
        }
        
        setVisibleMapRect(zoomRect, edgePadding: padding, animated: true)
    }
    
    var zoomLevel: Int {
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1);
        }
        
        set (newZoomLevel) {
            setCenter(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }
    
    func setCenter(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }
}
