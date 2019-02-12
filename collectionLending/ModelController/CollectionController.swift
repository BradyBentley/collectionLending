//
//  CollectionController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/5/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

typealias SuccessCompletion = (_ success: Bool) -> Void

class CollectionController {
    // MARK: - Properties
    static let shared = CollectionController(); private init(){}
    var collections: [Collection] = []
    
    // MARK: - CRUD
    // create
    func createAnItem(title: String, status: String, image: UIImage, count: Int, completion: @escaping SuccessCompletion) {
        let newItem = Collection(title: title, status: status, collectionItemImage: image, count: count)
        collections.append(newItem)
        Firebase.shared.saveItemToFirebase(collection: newItem) { (_) in
        completion(true)
        }
    }
    
    // update
    func updateItem(collection: Collection, title: String, status: String, count: Int, completion: @escaping SuccessCompletion) {
        collection.title = title
        collection.status = status
        collection.count = count
        Firebase.shared.updateItemsToFirebase(collection: collection, title: title, status: status, count: count) { (_) in
        }
        completion(true)
    }
    
    // delete
    func deleteItem(collection: Collection, completion: @escaping SuccessCompletion) {
        guard let index = collections.index(of: collection) else { completion(false) ; return }
        collections.remove(at: index)
        Firebase.shared.deleteAnItemFromFirebase(collection: collection) { (_) in
        }
        completion(true)
    }
}
