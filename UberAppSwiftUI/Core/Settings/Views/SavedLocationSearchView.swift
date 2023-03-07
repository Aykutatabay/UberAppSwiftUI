//
//  SavedLocationSearchView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 27.02.2023.
//

import SwiftUI

struct SavedLocationSearchView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    let config: SavedLocationViewModel
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                TextField("Search for a location", text: $viewModel.queryFragment)
                    .frame(height: 32)
                    .padding(.leading, 40)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding()
                    
                    
                
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .padding(.leading, 25)
                    .foregroundColor(.gray)
            }

            
            Spacer()
            LocationSearchResultView(config: .saveLocation(config), viewModel: viewModel)
        }
        .navigationTitle(config.subtitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SavedLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SavedLocationSearchView(config: .home)
        }
    }
}
