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
    let username: String
    
    // MARK: - Initialization
    init(uuid: String, username: String) {
        self.uuid = uuid
        self.username = username
    }
}
