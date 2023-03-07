//
//  Trip.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 1.03.2023.
//

import FirebaseFirestoreSwift
import Firebase

enum TripState: Int, Codable {
    case requested
    case rejected
    case accepted
    case passengerCancelled
    case driverCancelled
}


struct Trip: Identifiable, Codable {
    @DocumentID var tripId: String?
    let passengerUid: String
    let driverUid: String
    let passengerName: String
    let driverName: String
    let passengerLocation: GeoPoint
    let driverLocation: GeoPoint
    let pickupLocationName: String
    let pickupLocationAddress: String
    let dropoffLocationName: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let tripCost: Double
    var distanceToPassanger: Double
    var travelTimeToPassanger: Int
    var state: TripState
    
    var id: String {
        return tripId ?? ""
    }
}
