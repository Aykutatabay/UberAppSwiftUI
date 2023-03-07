//
//  SideMenuOptionView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 27.02.2023.
//

import SwiftUI

struct SideMenuOptionView: View {
    let option: SideMenuOptionViewModel
    var body: some View {
        HStack {
            Image(systemName: option.imageName)
                .font(.title2)
                .fontWeight(.semibold)
                .imageScale(.medium)
            
            Text(option.title)
                .font(.system(size: 16, weight: .semibold))
        }.foregroundColor(Color.colorTheme.primaryTextColor)
    }
}

struct SideMenuOptionView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionView(option: .messages)
    }
}
