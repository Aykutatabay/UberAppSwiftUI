//
//  UserService.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 1.03.2023.
//

import Firebase
import Combine

class UserService: ObservableObject {
    static let shared = UserService()
    @Published var user: User?
    var cancellables = Set<AnyCancellable>()
    init() {
        fetchUser()
    }
    func fetchUser() {
         publishUser()
         .sink { _ in
             
         } receiveValue: { [weak self] user in
             self?.user = user
         }.store(in: &cancellables)
    }
    
    func publishUser() -> AnyPublisher<User, Error> {
        Future<User, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
                print("DEBUG: Did fetch user rfom firestore !")
                if let error = error {
                    promise(.failure(error))
                }
                guard let snapshot = snapshot else { return }
                guard let user = try? snapshot.data(as: User.self) else { return }
                promise(.success(user))
            }
        }.eraseToAnyPublisher()
    }
}
