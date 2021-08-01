//
//  LocationManager.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import Foundation
import MapKit
import UIKitExtension
import FoundationExtension

typealias CLLocationResult = Result<CLLocation, Error>

protocol LocationManagerProtocol {
    
    func isLocationServiceAuthorized() -> Bool
    func getLocation(_ callback: @escaping ((CLLocationResult) -> Void))
    func requestLocation(from vc: UIViewController, callback: @escaping (CLAuthorizationStatus) -> Void)
    
    func startMonitorLocation()
    func stopMonitorLocation()
    
    func add(observer: AnyObject, callback: @escaping (CLLocationResult) -> Void)
    func remove(observer: AnyObject)
}

class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    
    // MARK: Private Properties
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var getLocationCallback: ((CLLocationResult) -> Void)?
    
    private var observers: [WeakContainer<AnyObject>: (CLLocationResult) -> Void] = [:] // they will observe real time location updates
    private let serialQueue = DispatchQueue(label: "LocationManagerDispatchQueue", attributes: .concurrent)
    private var isUpdatingLocation = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    // MARK: LocationManagerProtocol
    
    func remove(observer: AnyObject) {//return;
       // performOnSerialQueue { [unowned self] in
            for (container, _) in self.observers {
                guard let content = container.content else {
                    observers.removeValue(forKey: container)
                    continue
                }
                guard content === observer else {
                    continue
                }
                observers.removeValue(forKey: container)
                break
            }
            if observers.keys.isEmpty == true,
               getLocationCallback == nil
            {
                self.stopMonitorLocation()
            }
        //}
    }
    
    func add(observer: AnyObject, callback: @escaping (CLLocationResult) -> Void) {//return;
//        remove(observer: observer)
        
//        performOnSerialQueue { [unowned self] in
            for (container, _) in self.observers {
                guard let content = container.content else {
                    observers.removeValue(forKey: container)
                    continue
                }
                if content === observer {
                    return
                }
            }
            
            let container = WeakContainer(observer)
            self.observers[container] = callback
            self.startMonitorLocation()
        //}
    }
    
    func isLocationServiceAuthorized() -> Bool {
        var result = false
        let enabled = isLocationServicesEnabled() // is enabled on device
        if enabled == true {
            let authorizationStatus = self.getAuthorizationStatus()
            switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                result = true
            default:
                break
            }
        }
        return result
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        let result = CLLocationManager.authorizationStatus()
        return result
    }
    
    func isLocationServicesEnabled() -> Bool {
        let result = CLLocationManager.locationServicesEnabled()
        return result
    }
    
    func requestLocation(from vc: UIViewController, callback: @escaping (CLAuthorizationStatus) -> Void) {
        if isLocationServicesEnabled() == true {
            let authorizationStatus = self.getAuthorizationStatus()
            switch authorizationStatus {
            case .notDetermined:
                callback(authorizationStatus)
                locationManager.requestWhenInUseAuthorization()
                
            case .restricted, .denied:
                //TODO localize
                vc.alert.showQuestionAlert(title: "No location", message: "Please enable location service") { response in
                    guard response == true,
                          let url = URL(string: UIApplication.openSettingsURLString),
                          UIApplication.shared.canOpenURL(url) == true
                    else {
                        callback(authorizationStatus)
                        return
                    }
                    UIApplication.shared.open(url)
                    callback(.notDetermined)
                }
            case .authorizedAlways, .authorizedWhenInUse:
                callback(authorizationStatus)
            @unknown default:
                callback(.notDetermined)
            }
        } else {
            callback(.denied)
        }
    }
    
    func getLocation(_ callback: @escaping ((Result<CLLocation, Error>) -> Void)) {
        // Request a user’s location once
        if let location = lastLocation {
            callback(.success(location))
        } else {
            getLocationCallback = callback
            startMonitorLocation()
            //locationManager.requestLocation()  //requestLocation()
        }
    }
    
    func startMonitorLocation() {
        guard isUpdatingLocation == false else { return }
        isUpdatingLocation = true
        // Start updating location when app needs real time location updates, for example for car navigation
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitorLocation() {
        guard isUpdatingLocation == true else { return }
        isUpdatingLocation = false
        // Make sure to stop updating location when your app no longer needs location updates
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.lastLocation = location
        callObservers(with: .success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callObservers(with: .failure(error))
    }
    
    // MARK: Private Functions
    
    private func performOnSerialQueue(_ closure: @escaping () -> Void) {
        serialQueue.sync(flags: .barrier) {
            closure()
        }
    }
    
    private func callObservers(with result: CLLocationResult) {
        getLocationCallback?(result)
        getLocationCallback = nil
        
        if observers.isEmpty == true {
            stopMonitorLocation()
            return
        }
//        performOnSerialQueue { [unowned self] in
            for (_, observer) in self.observers {
                observer(result)
            }
//        }
    }
}
