//
//  UserController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/5/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    // MARK: - Properties
    static let shared = UserController() ; private init(){}
    var users: [User] = []
    var currentUser: User?
    
    // MARK: - Methods
    func createAUser(email: String, password: String, username: String, completion: @escaping SuccessCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print("❌Error creating a User: \(error) \(error.localizedDescription)")
                completion(false)
            }
            guard let auth = auth?.user.uid, !username.isEmpty else { completion(false) ; return }
            self.currentUser = User(uuid: auth, username: username)
            Firebase.shared.saveUser(user: User(uuid: auth, username: username), completion: { (_) in
            })
            completion(true)
        }
    }
    
    func signInAUser(email: String, password: String, completion: @escaping SuccessCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print("❌Error creating a User: \(error) \(error.localizedDescription)")
                completion(false)
            }
            guard let auth = auth?.user.uid else { completion(false) ; return }
            self.currentUser = User(uuid: auth)
            completion(true)
        }
    }
    
    func signOut(completion: @escaping SuccessCompletion) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completion(false)
        }
    }
    
    func updateFriend(friend: User, completion: @escaping SuccessCompletion) {
        guard let currentUser = currentUser else { completion(false) ; return }
        currentUser.friends.append(friend.uuid)
        Firebase.shared.updateFriendsArray(friend: friend) { (_) in
        }
        completion(true)
    }
    
    func removeFriend(friend: User, completion: SuccessCompletion) {
        guard let currentUser = currentUser, let index = currentUser.friends.index(of: friend.uuid) else { completion(false) ; return }
        currentUser.friends.remove(at: index)
        Firebase.shared.removeFriendFromArray(friend: friend) { (_) in
        }
        completion(true)
    }
}
