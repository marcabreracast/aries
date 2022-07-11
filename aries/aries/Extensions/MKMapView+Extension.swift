//
//  MKMapView+Extension.swift
//  aries
//
//  Created by Mar Cabrera on 08/06/2022.
//

import Foundation
import MapKit

extension MKMapView {
    /**
     Custom method that situates the center of the map given the location for better clarity
     */
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
