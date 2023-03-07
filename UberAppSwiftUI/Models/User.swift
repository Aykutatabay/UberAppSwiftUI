//
//  User.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 27.02.2023.
//

import Firebase

enum AccountType: Int, Codable {
    case passenger
    case driver
}

struct User: Codable {
    let fullName: String
    let email: String
    let uid: String
    var coordinates: GeoPoint
    var accountType: AccountType
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}
