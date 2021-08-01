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

/*
 Service for general access to user's location
 
 To use it, please do Inject:
 @Inject private var locationManager: LocationManagerProtocol
*/

protocol LocationManagerProtocol {
    
    func isLocationServiceAuthorized() -> Bool
    func getLocation(_ callback: @escaping ((CLLocationResult) -> Void))
    func requestLocation(from vc: UIViewController, callback: @escaping (CLAuthorizationStatus) -> Void)
    
    func startMonitorLocation()
    func stopMonitorLocation()
    
    func add(observer: AnyObject, callback: @escaping (CLLocationResult) -> Void)
    func remove(observer: AnyObject)
}

typealias CLLocationResult = Result<CLLocation, Error>

class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    
    // MARK: Private Properties
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var getLocationCallback: ((CLLocationResult) -> Void)?
    
    private var observers: [WeakContainer<AnyObject>: (CLLocationResult) -> Void] = [:] // they will observe real time location updates
    private var isUpdatingLocation = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    // MARK: LocationManagerProtocol
    
    func remove(observer: AnyObject) {
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
    }
    
    func add(observer: AnyObject, callback: @escaping (CLLocationResult) -> Void) {
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
    
    private func callObservers(with result: CLLocationResult) {
        getLocationCallback?(result)
        getLocationCallback = nil
        
        if observers.isEmpty == true {
            stopMonitorLocation()
            return
        }
        for (_, observer) in self.observers {
            observer(result)
        }
    }
}
