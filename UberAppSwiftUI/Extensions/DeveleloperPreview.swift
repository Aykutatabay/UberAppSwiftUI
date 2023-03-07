//
//  DeveleloperPreview.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 28.02.2023.
//

import Firebase
import SwiftUI

extension PreviewProvider {
    static var dev: DeveleloperPreview {
        return DeveleloperPreview.shared
    }
}

class DeveleloperPreview {
    static let shared = DeveleloperPreview()
    
    let mockTrip = Trip(passengerUid: NSUUID().uuidString, driverUid: NSUUID().uuidString, passengerName: "Aykut Atabay", driverName: "Ozan Atabay", passengerLocation: .init(latitude: 37.28, longitude: -122.1), driverLocation: .init(latitude: 37.28, longitude: -122.1), pickupLocationName: "Apple Campus", pickupLocationAddress: "123 Main Street, Palo Alto CA", dropoffLocationName: "Starbucks", pickupLocation: .init(latitude: 37.456, longitude: -122.15), dropoffLocation: .init(latitude: 37.042, longitude: -122.2), tripCost: 21.0, distanceToPassanger: 1000, travelTimeToPassanger: 5, state: .rejected)
    
    let mockUser = User(fullName: "Aykut", email: "aykut@gmail.com", uid: NSUUID().uuidString, coordinates: GeoPoint(latitude: 37.38, longitude: -122.05), accountType: .driver)
}
