//
//  LocationSearchView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var currentLocation: String = ""
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            // header view
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
                
                VStack(spacing: 15) {
                    TextField("Current Location", text: $currentLocation)
                        .frame(height: 40)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 40)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                    
                }.padding(.leading, 5)
                
            }
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            LocationSearchResultView(config: .ride, viewModel: viewModel)

        }.background(Color.colorTheme.backgroundColor)
    }
}
struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}


