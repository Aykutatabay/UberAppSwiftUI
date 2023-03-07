//
//  PickupPassengerView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 4.03.2023.
//

import SwiftUI

struct PickupPassengerView: View {
    let trip: Trip
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(.gray)
                .frame(width: 48, height: 6)
                .padding(.top)
            
            VStack {
                HStack {
                    Text("Pickup \(trip.passengerName) at \(trip.pickupLocationName)")
                        .lineLimit(2)
                        .bold()
                    Spacer()
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .overlay {
                            VStack {
                                Text("\(trip.travelTimeToPassanger)")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                Text("min")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                }.padding(.horizontal)
                
                Divider()
                
                HStack {
                    Image("Aykut1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70 )
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 3)
                    
                    // AYKUT
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(trip.passengerName)")
                            .bold()
                        
                        //star and rate
                        HStack(alignment: .bottom, spacing: 3) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .imageScale(.small)
                            Text("4.8")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 6) {
                        Text("Earnings")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.colorTheme.primaryTextColor)
                        Text("\(trip.tripCost.toCurrency())")
                            .font(.system(size: 20, weight: .bold))
                    }
                        
                }.padding(10)
                
                Divider()
                
                Button {
                    homeViewModel.cancelTripAsDriver()
                } label: {
                    Text("CANCEL TRIP")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.bottom, 25)
            }
        }
        .background(Color.colorTheme.backgroundColor)
        .cornerRadius(25)
    }
}

struct PickupPassengerView_Previews: PreviewProvider {
    static var previews: some View {
        PickupPassengerView(trip: dev.mockTrip)
    }
}
