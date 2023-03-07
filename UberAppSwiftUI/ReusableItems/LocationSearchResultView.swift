//
//  LocationSearchResultView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 28.02.2023.
//

import SwiftUI

struct LocationSearchResultView: View {
    let config: LocationResultsViewConfig
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id: \.self) { result in
                    Button {
                        viewModel.receivePublishedLocation(result, config: config)
                    } label: {
                        LocationResultCell(title: result.title, subtitle: result.subtitle)
                            .accentColor(Color.colorTheme.primaryTextColor)
                            .lineLimit(1)
                            
                    }
                }
            }
        }
    }
}
