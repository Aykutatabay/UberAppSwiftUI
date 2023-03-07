//
//  GeoPoint.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 2.03.2023.
//

import Firebase
import CoreLocation
extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
