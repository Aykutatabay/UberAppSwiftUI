//
//  RideRequestView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 25.02.2023.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .uberX
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(.gray)
                .frame(width: 48, height: 6)
                .padding(.top)
            
            HStack {
                VStack(spacing: 5) {
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 2, height: 45)
                    
                    
                    Rectangle()
                        .fill(Color(.black))
                        .frame(width: 8, height: 8)
                }
                .padding(.leading, 10)
                
                VStack(alignment: .leading, spacing: 42) {
                    
                    HStack {
                        Text("Current Location")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            
                        Spacer()
                        
                        Text(viewModel.pickUpTime ?? "")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }.padding(.horizontal)
                    
                    HStack {
                        if let selectedLocationTitle = viewModel.selectedLocationCoordinate?.title {
                            Text(selectedLocationTitle)
                                .fontWeight(.semibold)
                        }
                        
                        
                        Spacer()
                        
                        Text(viewModel.dropOffTime ?? "")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                    }.padding(.horizontal)
                }
            }.padding(.top)
            
            Divider()
                .padding(.top)
            
            Text("SUGGESTED RIDES")
                .frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.top)
                .foregroundColor(.gray)
            
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(RideType.allCases) { type in
                        VStack(alignment: .leading) {
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(type.description)
                                    .font(.system(size: 16, weight: .semibold))
                                    
                                
                                Text("\(viewModel.computeRiderPrice(for: type).toCurrency())")
                                    .font(.system(size: 16, weight: .semibold))
                            }.padding(.leading)
                            
                            
                        }
                        .frame(width: 112, height: 140)
                        .foregroundColor(selectedRideType == type ? .white : Color.colorTheme.primaryTextColor)
                        .background(selectedRideType == type ? Color(.systemBlue) : Color.colorTheme.secondaryBackground)
                        .scaleEffect(selectedRideType == type ? 1.25 : 1)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                self.selectedRideType = type
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            HStack(spacing:12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .foregroundColor(.white)
                    
                
                Text("****1234")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            .background(Color.colorTheme.secondaryBackground)
            .cornerRadius(10)
            .padding(.horizontal)
            
            
            Button {
                viewModel.requestTrip()
                viewModel.results = []
            } label: {
                Text("CONFIRM RIDE")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 25)
            
        }
        .background(Color.colorTheme.backgroundColor)
        .cornerRadius(25)

    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
    }
}
