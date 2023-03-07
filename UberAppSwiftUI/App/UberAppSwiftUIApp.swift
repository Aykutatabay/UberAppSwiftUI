//
//  UberAppSwiftUIApp.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()


    return true
  }
}

@main
struct UberAppSwiftUIApp: App {
    //@StateObject var viewModel = LocationSearchViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            HomeView()
                //.environmentObject(viewModel)
                .environmentObject(authViewModel)
                .environmentObject(homeViewModel)
        }
    }
}
