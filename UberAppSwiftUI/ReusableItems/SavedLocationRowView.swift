//
//  SavedLocationRowView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 27.02.2023.
//

import SwiftUI

struct SavedLocationRowView: View {
    let imageName: String
    let title: String
    let subtitle: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.colorTheme.primaryTextColor)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SavedLocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocationRowView(imageName: "house.circle.fill", title: "Home", subtitle: "Add Home")
    }
}
