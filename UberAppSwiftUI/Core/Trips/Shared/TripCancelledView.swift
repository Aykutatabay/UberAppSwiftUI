//
//  TripCancelledView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 5.03.2023.
//

import SwiftUI

struct TripCancelledView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(.gray)
                .frame(width: 48, height: 6)
                .padding(.top)
            
            Text(homeViewModel.tripCancelledMessage)
                .font(.headline)
                .padding(.vertical)
            
            Button {
                guard let user = homeViewModel.currentUser else { return }
                guard let trip = homeViewModel.trip else { return }
                
                if user.accountType == .passenger {
                    if trip.state == .driverCancelled {
                        homeViewModel.deleteTrip()
                    } else if trip.state == .passengerCancelled {
                        homeViewModel.trip = nil
                    }
                } else {
                    if trip.state == .passengerCancelled {
                        homeViewModel.deleteTrip()
                    } else if trip.state == .driverCancelled {
                        homeViewModel.trip = nil
                    }
                }
                
            } label: {
                Text("OK")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
            }
            
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.colorTheme.backgroundColor)
        .cornerRadius(20)
    }
}

struct TripCancelledView_Previews: PreviewProvider {
    static var previews: some View {
        TripCancelledView()
    }
}
