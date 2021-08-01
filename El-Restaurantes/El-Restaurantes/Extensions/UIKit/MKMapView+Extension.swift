//
//  MKMapView+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import MapKit

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
    
    func removeAllAnotations() {
        let allAnnotations = self.annotations
        removeAnnotations(allAnnotations)
    }
}
