//
//  Collection.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/5/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}

class Collection {
   // MARK: - Properties
    var title: String
    var status: String
    var collectionItemImage: UIImage?
    var count: Int
    var uuid: String
    var username: String?
    
    
    // MARK: - Keys
    enum collectionKeys {
        static let titleKey = "title"
        static let statusKey = "status"
        static let collectionItemImageKey = "collectionItemImage"
        static let countKey = "count"
        static let uuidKey = "uuid"
        static let userKey = "users"
        static let collectionKey = "collection"
        static let belongsToKey = "belongsToKey"
    }
    
    // MARK: - Initialization
    init(title: String, status: String, collectionItemImage: UIImage?, count: Int, friends: [String] = [], uuid: String = UUID().uuidString) {
        self.title = title
        self.status = status
        self.collectionItemImage = collectionItemImage
        self.count = count
        self.uuid = uuid
    }
    
    convenience init?(firebaseDictionary: [String: Any]) {
        guard let title = firebaseDictionary[collectionKeys.titleKey] as? String,
        let status = firebaseDictionary[collectionKeys.statusKey] as? String,
        let count = firebaseDictionary[collectionKeys.countKey] as? Int,
        let uuid = firebaseDictionary[collectionKeys.uuidKey] as? String else { return nil }
        self.init(title: title, status: status, collectionItemImage: nil, count: count, uuid: uuid)
    }
}

extension Collection {
    var dictionary: [String: Any] {
        return [collectionKeys.titleKey: title,
                collectionKeys.statusKey: status,
                collectionKeys.countKey: count,
                collectionKeys.uuidKey: uuid
        ]
    }
}

// MARK: - Equatable
extension Collection: Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.title == rhs.title && lhs.count == rhs.count && lhs.uuid == rhs.uuid
    }
}

// MARK: - Searchable
extension Collection: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return self.title.lowercased().contains(searchTerm.lowercased())
    }
}


