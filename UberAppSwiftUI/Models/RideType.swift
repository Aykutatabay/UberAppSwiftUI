//
//  RideType.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 25.02.2023.
//

import Foundation
enum RideType: Int, CaseIterable, Identifiable {
    case uberX
    case uberBlack
    case uberXL
    
    var id: Int {
        return rawValue
    }
    var description: String {
        switch self {
        case .uberX:
            return "uberX"
        case .uberBlack:
            return "uberBlack"
        case .uberXL:
            return "uberXL"
        }
    }
    var imageName: String {
        switch self {
        case .uberX:
            return "UberXIcon"
        case .uberBlack:
            return "uber-black"
        case .uberXL:
            return "UberXIcon"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX:
            return 5
        case .uberBlack:
            return 20
        case .uberXL:
            return 10
        }
    }
    
    func computePrice(for distenceInMeter: Double) -> Double {
        let distenceInMiles = distenceInMeter / 1600
        switch self {
        case .uberX:
            return distenceInMiles * 1.5 + baseFare
        case .uberBlack:
            return distenceInMiles * 2.0 + baseFare
        case .uberXL:
            return distenceInMiles * 1.75 + baseFare
        }
    }
    
}
