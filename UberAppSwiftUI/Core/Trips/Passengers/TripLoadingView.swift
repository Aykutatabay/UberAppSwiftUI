//
//  TripLoadingView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 3.03.2023.
//

import SwiftUI

struct TripLoadingView: View {
    @EnvironmentObject var homeVieweModel: HomeViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(.gray)
                .frame(width: 48, height: 6)
                .padding(.top)
            
            
            HStack {
                Text("Connecting you to a driver...")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                Spinner(lineWidth: 5, height: 50, width: 50)
                    .padding(.trailing)
            }.padding(.bottom, 75)
            
                 
        }
        .background(Color.colorTheme.backgroundColor)
        .cornerRadius(25)
    }
}

struct TripLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        TripLoadingView()
    }
}
