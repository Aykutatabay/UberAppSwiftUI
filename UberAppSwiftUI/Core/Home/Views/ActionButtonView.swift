//
//  ActionButtonView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import SwiftUI

struct ActionButtonView: View {
    @Binding var mapState: MapViewState
    @Binding var showSideMenu: Bool
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        Button {
            withAnimation(.spring()) {
                changeButtonState()
            }
        } label: {
            Image(systemName: showActionImage())
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black ,radius: 6)
            
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)

    }
    
    func showActionImage() -> String {
        switch mapState {
        case .noInput:
            return "line.3.horizontal"
        case .searchingLocation, .locationSelected, .polylineAdded, .tripAccepted, .tripRejected, .tripRequested, .tripCancelledByDriver, .tripCancelledByPassenger:
            return "arrow.left"
        }
    }
    func changeButtonState() {
        switch mapState {
        case .noInput:
            withAnimation(.easeIn) {
                showSideMenu.toggle()
            }
            
        case.searchingLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded, .tripAccepted, .tripRejected, .tripRequested, .tripCancelledByDriver, .tripCancelledByPassenger:
            mapState = .noInput
            viewModel.selectedLocationCoordinate = nil
        }
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView(mapState: .constant(.locationSelected), showSideMenu: .constant(true))
    }
}
