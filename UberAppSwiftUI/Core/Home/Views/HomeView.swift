//
//  HomeView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import SwiftUI

struct HomeView: View {
    //@EnvironmentObject var viewModel: LocationSearchViewModel
    @State private var mapState: MapViewState = .noInput
    @State private var showSideMenu: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else {
                NavigationStack {
                    ZStack {
                        if let user = authViewModel.user {
                            SideMenuView(user: user).padding(.leading)
                            
                            mapView
                        }
                    }
                }.accentColor(Color.colorTheme.primaryTextColor)
            }
        }
    }
}

extension HomeView {
    var mapView: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                MapRepresentableView(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 64)
                        .opacity(0.9)
                        .onTapGesture {
                            withAnimation {
                                mapState = .searchingLocation
                                homeViewModel.queryFragment = ""
                            }
                        }
                }
                else if mapState == .searchingLocation {
                    LocationSearchView()
                        .padding(.horizontal)
                } else if mapState == .locationSelected {
                    
                }
                
                ActionButtonView(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading, 30)
            }
            
            if let user = authViewModel.user {
                homeViewModel.viewForState(mapState, user: user)
                    .transition(.move(edge: .bottom))
                    .padding(.horizontal)
                /*
                 if user.accountType == .passenger {
                     if mapState == .locationSelected || mapState == .polylineAdded {
                         RideRequestView()
                             .transition(.move(edge: .bottom))
                             .padding(.horizontal)
                     } else if mapState == .tripRequested {
                         TripLoadingView()
                             .padding(.horizontal)
                             .transition(.move(edge: .bottom))
                     } else if mapState == .tripAccepted {
                         TripAcceptedView()
                             .padding(.horizontal)
                             .transition(.move(edge: .bottom))
                     } else if mapState == .tripRejected{
                         // show trip rejection view
                     }
                 } else {
                     if let trip = homeViewModel.trip {
                         if mapState == .tripRequested {
                             AcceptTripView(trip)
                                 .padding(.horizontal)
                                 .transition(.move(edge: .bottom))
                         } else if mapState == .tripAccepted {
                             PickupPassengerView(trip: trip)
                                 .padding(.horizontal)
                                 .transition(.move(edge: .bottom))
                         }
                     }
                 }
                 */
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .offset(x: showSideMenu ?  316 : 0)
        .blur(radius: showSideMenu ? 1.5 : 0)
        .onTapGesture {
            if showSideMenu {
                withAnimation(.easeInOut) {
                    showSideMenu = false
                }
            } else { return }
        }
        .shadow(color: showSideMenu ? .black : .clear, radius: 10)
        .onReceive(homeViewModel.$selectedLocationCoordinate) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }.onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else {
                self.mapState = .noInput
                return
            }
            
            withAnimation(.spring()) {
                guard let user = authViewModel.user else { return }
                if mapState != .noInput || user.accountType == .driver {
                    switch trip.state {
                    case .requested:
                        mapState = .tripRequested
                    case .rejected:
                        mapState = .tripRejected
                    case .accepted:
                        mapState = .tripAccepted
                    case .passengerCancelled:
                        self.mapState = .tripCancelledByPassenger
                    case .driverCancelled:
                        self.mapState = .tripCancelledByDriver
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
