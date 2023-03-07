//
//  Color.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 26.02.2023.
//

import Foundation
import SwiftUI

extension Color {
    static let colorTheme = ColorTheme()
}
struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackground = Color("SecondaryBackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
}
