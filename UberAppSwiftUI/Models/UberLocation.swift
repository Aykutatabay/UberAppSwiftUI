//
//  UberLocation.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 26.02.2023.
//

import CoreLocation

struct UberLocation: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
}
