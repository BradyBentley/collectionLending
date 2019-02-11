//
//  Firebase.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit
import Firebase

class Firebase {
    // MARK: - Properties
    static let shared = Firebase(); private init (){}
    let firestore = Firestore.firestore()
    var ref: DocumentReference?
    let storage = Storage.storage()
    
    // MARK: - CRUD
    func saveItemToFirebase(collection: Collection, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Collection.collectionKeys.collectionKey).document(collection.uuid)
        docRef.setData(collection.dictionary)
        completion(true)
    }
    
    func fetchItemsFromFirebase(completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Collection.collectionKeys.collectionKey).getDocuments { (query, error) in
            if let error = error {
                print("❌Error creating a User: \(error) \(error.localizedDescription)")
                completion(false)
            }
            guard let documents = query?.documents else { completion(false) ; return }
            let collections = documents.compactMap { Collection(firebaseDictionary: $0.data())}
            print("Successfully pulled data>>>>>>>>>>>>>>>>>>>>")
            CollectionController.shared.collections = collections
            completion(true)
        }
    }
    
    func updateItemsToFirebase(collection: Collection, title: String, status: String, count: Int, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Collection.collectionKeys.collectionKey).document(collection.uuid)
        docRef.updateData([Collection.collectionKeys.titleKey: title,
                           Collection.collectionKeys.statusKey: status,
                           Collection.collectionKeys.countKey: count
            ])
        completion(true)
    }
    
    func deleteAnItemFromFirebase(collection: Collection, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Collection.collectionKeys.collectionKey).document(collection.uuid)
        docRef.delete()
        completion(true)
    }
    
    func savingItemImageToStorage(image: UIImage, title: String, completion: @escaping SuccessCompletion) {
        let storageRef = storage.reference()
        let image = image
        guard let currentUser = UserController.shared.currentUser?.uuid, let pictureData = image.pngData() else { completion(false) ; return }
        let pictureRef = storageRef.child("\(currentUser)/\(title).png")
        pictureRef.putData(pictureData, metadata: nil) { (_, error) in
            if let error = error {
                print("❌Error creating a User: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        completion(true)
    }
    
    func savingBorrowerImageToStorage(image: UIImage, title: String, completion: @escaping SuccessCompletion) {
        let storageRef = storage.reference()
        let image = image
        guard let pictureData = image.pngData() else { completion(false) ; return }
        let pictureRef = storageRef.child("borrowerImages/\(title).png")
        pictureRef.putData(pictureData, metadata: nil) { (_, error) in
            if let error = error {
                print("❌Error creating a User: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        completion(true)
    }
    
    func fetchItemImage(title: String, completion: @escaping (UIImage?) -> Void) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { return }
        let gsReference = storage.reference(forURL: "gs://collectionlending.appspot.com/\(currentUser)/\(title).png")
        gsReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("❌Error creating a User: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    func fetchBorrowerImage(collection: Collection, completion: @escaping (UIImage?) -> Void) {
        let gsReference = storage.reference(forURL: "gs://collectionlending.appspot.com/borrowerImages/\(collection.title).png")
        gsReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("❌Error creating a User: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
}
