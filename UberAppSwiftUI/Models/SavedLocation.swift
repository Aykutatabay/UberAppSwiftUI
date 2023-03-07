//
//  SavedLocation.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 28.02.2023.
//

import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinate: GeoPoint
    
}
