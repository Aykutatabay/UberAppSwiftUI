//
//  SideMenuView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 27.02.2023.
//

import SwiftUI

struct SideMenuView: View {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack(spacing: 50) {
            header
            Divider()
                .padding(.top, -25)
            option
            Spacer()
        }
        .padding(.top, 32)
        .background(Color.colorTheme.backgroundColor)
    }
}

// MARK: - Extension

extension SideMenuView {
    var header: some View {
        VStack(alignment: .leading,spacing: 32) {
            HStack {
                Image("Aykut1")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 72,height: 72)
                    .shadow(color: .black ,radius: 4)
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.fullName)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(user.email)
                        .font(.system(size: 14, weight: .semibold))
                        .accentColor(Color.colorTheme.primaryTextColor)
                        .opacity(0.77)
                    
                }.padding(.leading, 8)
            }
            
            VStack(alignment: .leading,spacing: 16) {
                Text("Do more your account")
                .font(.footnote)
                .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .font(.title2)
                        .imageScale(.medium)
                    Text("Make Money Driving")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(6)
                }
            }
        }
        .foregroundColor(Color.colorTheme.primaryTextColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
    }
    var option: some View {
        VStack(alignment: .leading, spacing: 50) {
            ForEach(SideMenuOptionViewModel.allCases) { option in
                NavigationLink(value: option) {
                    SideMenuOptionView(option: option)
                        
                }

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
        .navigationDestination(for: SideMenuOptionViewModel.self) { option in
            switch option {
            case .trips:
                Text("")
            case .wallet:
                Text("")
            case .settings:
                SettingsView(user: user)
            case .messages:
                Text("")
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SideMenuView(user: dev.mockUser)
        }
    }
}
