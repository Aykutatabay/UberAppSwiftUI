//
//  LocationResultCell.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import SwiftUI
import MapKit


struct LocationResultCell: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .accentColor(.white)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    
                
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Divider()
            }.padding(.leading)
        }.padding(.leading)
    }
}

struct LocationResultCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationResultCell(title: "Starbucks", subtitle: "Narlidere")
    }
}
