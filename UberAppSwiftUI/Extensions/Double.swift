//
//  Double.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 25.02.2023.
//

import Foundation
extension Double {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    private var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter
    }
    
    func toCurrency() -> String {
        return currencyFormatter.string(for: self) ?? ""
    }
    
    func toOneDecimal() -> String {
        return decimalFormatter.string(for: self) ?? ""
    }
    
}
