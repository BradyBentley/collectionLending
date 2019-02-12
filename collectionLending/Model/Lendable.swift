//
//  Lendable.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class Lendable {
    // MARK: - Properties
    var friendsName: String
    var dueDate: Date
    var isReturned: Bool
    var borrowerImage: UIImage?
    let uuid: String
    var title: String
    
    // MARK: - CodingKeys
    enum lendableKeys {
        static let friendsNameKey = "friendsName"
        static let dueDateKey = "dueDate"
        static let isReturnedKey = "isReturned"
        static let borrowerImageKey = "borrowerImage"
        static let lendableKey = "lendable"
        static let uuidKey = "uuid"
        static let titleKey = "title"
    }
    
    // MARK: - Initialization
    init(friendsName: String, dueDate: Date, isReturned: Bool = false, borrowerImage: UIImage?, uuid: String = UUID().uuidString, title: String) {
        self.friendsName = friendsName
        self.dueDate = dueDate
        self.isReturned = isReturned
        self.borrowerImage = borrowerImage
        self.uuid = uuid
        self.title = title
    }
    
    convenience init?(firebase: [String: Any]) {
        guard let friendsName = firebase[lendableKeys.friendsNameKey] as? String,
            let dueDate = firebase[lendableKeys.dueDateKey] as? Date,
            let isReturned = firebase[lendableKeys.isReturnedKey] as? Bool,
            let uuid = firebase[lendableKeys.uuidKey] as? String,
            let title = firebase[lendableKeys.titleKey] as? String else { return nil}
        self.init(friendsName: friendsName, dueDate: dueDate, isReturned: isReturned, borrowerImage: nil, uuid: uuid, title: title)
    }
}

extension Lendable {
    var dictionary: [String: Any] {
        return [
            lendableKeys.friendsNameKey: friendsName,
            lendableKeys.dueDateKey: dueDate as Any,
            lendableKeys.isReturnedKey: isReturned,
            lendableKeys.uuidKey: uuid,
            lendableKeys.titleKey: title
        ]
    }
}

// MARK: - Equatable
extension Lendable: Equatable {
    static func == (lhs: Lendable, rhs: Lendable) -> Bool {
        return lhs.friendsName == rhs.friendsName && lhs.uuid == rhs.uuid && lhs.title == rhs.title
    }
}
