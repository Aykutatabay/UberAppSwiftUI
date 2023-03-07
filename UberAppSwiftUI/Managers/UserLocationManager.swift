//
//  UserLocationManager.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import CoreLocation

class UserLocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = UserLocationManager()
    @Published var userlocaiton: CLLocationCoordinate2D?
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
extension UserLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userlocaiton = location.coordinate
        locationManager.stopUpdatingLocation()
    }
}
