//
//  FriendController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/11/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import Foundation

class FriendController {
    // MARK: - Properties
    static let shared = FriendController()
    var friends: [User] = []
    var friendsCollections: [Collection] = []
    
    // MARK: - Methods
    func addToFriendsList(uuid: String, username: String, completion: @escaping SuccessCompletion) {
        let newFriend = User(uuid: uuid, username: username)
        friends.append(newFriend)
        UserController.shared.updateFriend(friend: newFriend) { (_) in
        }
        completion(true)
    }
    
    func removeFriendFromList(user: User, friend: User, completion: @escaping SuccessCompletion) {
        guard let index = friends.index(of: friend) else { completion(false) ; return }
        friends.remove(at: index)
        UserController.shared.removeFriend(friend: friend) { (_) in
        }
        completion(true)
    }
}
