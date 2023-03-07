//
//  LocationSearchActivationView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        
        
        HStack {
            Rectangle()
                .fill(.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            
            Text("Where to?")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(color: .black, radius: 6)
        )
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
