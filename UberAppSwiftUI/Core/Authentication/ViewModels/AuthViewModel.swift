//
//  AuthViewModel.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 26.02.2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var user: User?
    var cancellables = Set<AnyCancellable>()
    let userLocationManager = UserLocationManager.shared
    let userService = UserService.shared
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func signIn(withEmail: String, password: String) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { result, error in
            if let error = error {
                print("ERROR: User couldnt log in",error.localizedDescription,withEmail)
                return // we dont want our function go further
            }
            
            if let user = result?.user {
                self.userSession = user
                print("BU USER KIM AMK AUTH2", user)
                self.userService.fetchUser()
                
            }
        }
        
    }
    
    func registerUser(withEmail email: String, password: String, fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("ERROR: User couldnt created",error.localizedDescription)
                return // we dont want our function go further
            }
            if let user = result?.user, let coordinate = self.userLocationManager.userlocaiton {
                let latitude = coordinate.latitude
                let longitude = coordinate.longitude
                self.userSession = user
                let user = User(fullName: fullName, email: email, uid: user.uid, coordinates: GeoPoint(latitude: latitude, longitude: longitude), accountType: .driver)
                
                do {
                    let encodedUser = try Firestore.Encoder().encode(user)
                    Firestore.firestore().collection("users").document(user.uid).setData(encodedUser)
                    self.user = user
                } catch let error {
                    print("ERROR: problem with encoded the user",error.localizedDescription)
                }
            }
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.user = nil
        } catch let error {
            print("ERROR: Filed to signout", error.localizedDescription)
        }
    }
    
    func fetchUser() {
        userService.$user
            .sink { _ in
                
            } receiveValue: { [weak self] user in
                guard let user = user else { return }
                self?.user = user
            }.store(in: &cancellables)
    }
}

