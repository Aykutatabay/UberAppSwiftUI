//
//  TripAcceptedView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 3.03.2023.
//

import SwiftUI

struct TripAcceptedView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        
        VStack {
            Capsule()
                .foregroundColor(.gray)
                .frame(width: 48, height: 6)
                .padding(.top)
            if let trip = homeViewModel.trip {
                VStack {
                    HStack {
                        Text("Meet your driver at \(trip.pickupLocationName) for your trip to \(trip.dropoffLocationName)")
                            .lineLimit(2)
                            .frame(width: 200)
                            .bold()
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .overlay {
                                VStack {
                                    Text(String(trip.travelTimeToPassanger))
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                    
                                    Text("min")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
                            }
                    }.padding(.horizontal)
                    
                    Divider()
                }
                
                HStack {
                    Image("Aykut1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70 )
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 3)
                    
                    // AYKUT
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Aykut Atabay")
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
                    
                    // driver wehicle info
                    
                    VStack {
                        Image("UberXIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 64)
                        HStack {
                            Text("Mercedes S -")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                
                            Text("5G4K08")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(width: 160)
                        .padding(.bottom)
                    }
                    
                }.padding(10)
            }
            
            Button {
                homeViewModel.cancelTripAsPassenger()
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
        .background(Color.colorTheme.backgroundColor)
        .cornerRadius(25)
        
    }
    
}

struct TripAcceptedView_Previews: PreviewProvider {
    static var previews: some View {
        TripAcceptedView()
    }
}
