//
//  SettingsView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 27.02.2023.
//

import SwiftUI

struct SettingsView: View {
    private let user: User
    @EnvironmentObject var authViewModel: AuthViewModel
    init(user: User) {
        self.user = user
    }
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        Image("Aykut1")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 64,height: 64)
                            //.shadow(color: .black ,radius: 4)
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullName)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(user.email)
                                .font(.system(size: 14, weight: .semibold))
                                .accentColor(Color.colorTheme.primaryTextColor)
                                .opacity(0.77)
                            
                        }.padding(.leading, 8)
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) {savedLocation  in
                        NavigationLink(value: savedLocation) {
                            SavedLocationRowView(imageName: savedLocation.imageName, title: savedLocation.title, subtitle: savedLocation.subtitle(forUser: user))
                                
                        }.navigationDestination(for: SavedLocationViewModel.self) { savedLocation in
                            switch savedLocation {
                                case .work:
                                SavedLocationSearchView(config: .work)
                                    
                                case .home:
                                SavedLocationSearchView(config: .home)
                                    
                            }
                        }
                    }
                }
                
                Section("Settings") {
                    SettingsRowView(imageName: "bell.circle.fill", title: "Notification", tintColor: .purple)
                    SettingsRowView(imageName: "creditcard.circle.fill", title: "Payment Method", tintColor: .blue)
                    
                }
                Section("Account") {
                    SettingsRowView(imageName: "dollarsign.square.fill", title: "Make Money Driving", tintColor: .green)
                    Button {
                        authViewModel.signout()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.square.fill", title: "Sign Out", tintColor: .pink)
                    }
                }
            }
        }.navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(user: dev.mockUser)
        }
    }
}
