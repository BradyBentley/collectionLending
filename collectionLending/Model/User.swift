//
//  User.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/5/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import Foundation

class User {
    // MARK: - Properties
    let uuid: String
    var username: String
    var friends: [String]
    
    // MARK: - Coding Keys
    enum userKeys {
        static let uuidKey = "uuid"
        static let usernameKey = "username"
        static let friendsKey = "friends"
    }
    
    // MARK: - Initialization
    init(uuid: String, username: String = "", friends: [String] = []) {
        self.uuid = uuid
        self.username = username
        self.friends = friends
    }
    
    convenience init?(firebaseUser: [String: Any]) {
        guard let uuid = firebaseUser[userKeys.uuidKey] as? String,
            let username = firebaseUser[userKeys.usernameKey] as? String,
        let friends = firebaseUser[userKeys.friendsKey] as? [String] else { return nil }
        self.init(uuid: uuid, username: username, friends: friends)
    }
}

// MARK: - Equatable
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username && lhs.uuid == rhs.uuid
    }
}

extension User {
    var dictionary: [String: Any] {
        return [
            userKeys.uuidKey: uuid,
            userKeys.usernameKey: username,
            userKeys.friendsKey: friends
        ]
    }
}
