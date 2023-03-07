//
//  MapViewState.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 25.02.2023.
//

import Foundation

enum MapViewState {
    case noInput
    case searchingLocation
    case locationSelected
    case polylineAdded
    case tripRequested
    case tripRejected
    case tripAccepted
    case tripCancelledByPassenger
    case tripCancelledByDriver
}
