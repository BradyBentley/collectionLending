//
//  Collection.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/5/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class Collection {
   // MARK: - Properties
    var title: String
    var dueDate: Date?
    var status: String
    var collectionItemImage: UIImage?
    var borrowerItemImage: UIImage?
    var count: Int
    var friends: [String]
    var uuid: String
    
    // MARK: - Keys
    enum collectionKeys {
        static let titleKey = "title"
        static let dueDateKey = "dueDate"
        static let statusKey = "status"
        static let collectionItemImageKey = "collectionItemImage"
        static let borrowerItemImageKey = "borrowerItemImage"
        static let countKey = "count"
        static let friendsKey = "friends"
        static let uuidKey = "uuid"
        static let userKey = "users"
        static let collectionKey = "collection"
    }
    
    // MARK: - Initialization
    init(title: String, status: String, count: Int, friends: [String] = [], uuid: String = UUID().uuidString) {
        self.title = title
        self.status = status
        self.count = count
        self.friends = friends
        self.uuid = uuid
    }
    
    convenience init?(firebaseDictionary: [String: Any]) {
        guard let title = firebaseDictionary[collectionKeys.titleKey] as? String,
        let status = firebaseDictionary[collectionKeys.statusKey] as? String,
//        let dueDate = firebaseDictionary[collectionKeys.dueDateKey] as? Date,
//        let collectionItemImage = firebaseDictionary[collectionKeys.collectionItemImageKey] as? UIImage?,
//        let borrowerItemImage = firebaseDictionary[collectionKeys.borrowerItemImageKey] as? UIImage?,
        let count = firebaseDictionary[collectionKeys.countKey] as? Int,
        let friends = firebaseDictionary[collectionKeys.friendsKey] as? [String],
        let uuid = firebaseDictionary[collectionKeys.uuidKey] as? String else { return nil }
        self.init(title: title, status: status, count: count, friends: friends, uuid: uuid)
//        self.dueDate = dueDate
//        self.collectionItemImage = collectionItemImage
//        self.borrowerItemImage = borrowerItemImage
        
    }
}

extension Collection {
    var dictionary: [String: Any] {
        return [collectionKeys.titleKey: title,
                collectionKeys.dueDateKey: dueDate as Any,
                collectionKeys.statusKey: status,
                collectionKeys.collectionItemImageKey: collectionItemImage as Any,
                collectionKeys.borrowerItemImageKey: borrowerItemImage as Any,
                collectionKeys.countKey: count,
                collectionKeys.friendsKey: friends,
                collectionKeys.uuidKey: uuid
        ]
    }
}

// MARK: - Equatable
extension Collection: Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.title == rhs.title && lhs.count == rhs.count && lhs.status == rhs.status
    }
}
