//
//  DriverAnnotation.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 28.02.2023.
//

import MapKit
import Firebase

class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let uid: String
    
    init(driver: User) {
        self.coordinate = CLLocationCoordinate2D(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
        self.uid = driver.uid
    }
}
