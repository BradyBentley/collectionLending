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
    
    // MARK: - Methods
    func addToFriendsList(uuid: String, username: String, completion: @escaping SuccessCompletion) {
        let newFriend = User(uuid: uuid, username: username)
        friends.append(newFriend)
    }
    
    func removeFriendFromList(user: User, completion: @escaping SuccessCompletion) {
        guard let index = friends.index(of: user) else { completion(false) ; return }
        friends.remove(at: index)
    }
}
