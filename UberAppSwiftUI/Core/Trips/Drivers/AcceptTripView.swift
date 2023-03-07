//
//  AcceptTripView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 1.03.2023.
//

import SwiftUI
import MapKit

struct AcceptTripView: View {
    @State var region: MKCoordinateRegion
    let trip: Trip
    let annotationItem: UberLocation
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    init(_ trip: Trip) {
        
        let center = CLLocationCoordinate2D(latitude: trip.pickupLocation.latitude, longitude: trip.pickupLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
        self.trip = trip
        self.annotationItem = UberLocation(title: trip.pickupLocationName, coordinate: trip.pickupLocation.toCoordinate())
    }
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(.gray)
                .frame(width: 48, height: 6)
                .padding(.top)
            // would you like to pick up view
            VStack {
                HStack {
                    Text("Would you like to pick up this passenger ?")
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
                
                HStack {
                    Image("Aykut1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70 )
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 3)
                    
                    // AYKUT
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trip.passengerName)
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
                        Text(trip.tripCost.toCurrency())
                            .font(.system(size: 20, weight: .bold))
                    }
                    
                   
                        
                }.padding(10)
                
                Divider()
                
                VStack(spacing: 6) {
                    HStack {
                        Text(trip.pickupLocationName)
                            .font(.system(size: 14))
                            .bold()
                        
                        Spacer()
                        
                        Text(trip.distanceToPassanger.toOneDecimal())
                            .font(.system(size: 15))
                            .bold()
                    }
                    HStack {
                        Text(trip.pickupLocationAddress)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("ml")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }.padding(.horizontal)
                Map(coordinateRegion: $region, annotationItems: [annotationItem], annotationContent: { annotationItem in
                    MapMarker(coordinate: annotationItem.coordinate, tint: .black)
                })
                    .frame(width: UIScreen.main.bounds.width - 16, height: 225)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .black, radius: 10)
                    .padding(.vertical, 10)

                Divider()
                
                HStack(spacing: 40) {
                    Button {
                        homeViewModel.rejectTrip()
                    } label: {
                        Rectangle()
                            .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                            .foregroundColor(.pink)
                            .cornerRadius(10)
                            .overlay {
                                Text("Reject")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                    }
                    
                    Button {
                        homeViewModel.acceptTrip()
                    } label: {
                        Rectangle()
                            .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                            .overlay {
                                Text("Accept")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                    }
                    
                    
                }.padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 25)
                    
            }
        }
        .background(Color.colorTheme.backgroundColor)
        .cornerRadius(25)
    }
}


 struct AcceptTripView_Previews: PreviewProvider {
     static var previews: some View {
         AcceptTripView(dev.mockTrip)
     }
 }
 

