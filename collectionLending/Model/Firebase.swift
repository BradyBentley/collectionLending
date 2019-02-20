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
    
    // MARK: Collection Items to Firebase
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
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(false)
            }
            guard let documents = query?.documents else { completion(false) ; return }
            let collections = documents.compactMap { Collection(firebaseDictionary: $0.data())}
            CollectionController.shared.collections = collections
            for collection in collections {
                self.fetchItemImage(title: collection.title, completion: { (image) in
                    collection.collectionItemImage = image
                    completion(true)
                })
            }
        }
    }
    
    func fetchFriends(completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser else { completion(false) ; return }
        var friends: [User] = []
        for friendsUUID in currentUser.friends {
            let docRef = firestore.collection(Collection.collectionKeys.userKey).document(friendsUUID)
            docRef.getDocument { (document, error) in
                if let error = error {
                    print("❌Error: \(error) \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let document = document?.data(),
                let friend = User(firebaseUser: document) else { completion(false) ; return }
                friends.append(friend)
                FriendController.shared.friends = friends
                completion(true)
            }
        }
    }
    
    func fetchItemForFriend(friendUsername: String, friendUUID: String, completion: @escaping SuccessCompletion) {
        firestore.collection(Collection.collectionKeys.userKey).document(friendUUID).collection(Collection.collectionKeys.collectionKey).getDocuments { (query, error) in
            if let error = error {
                print("❌Error obtaining documents: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let documents = query?.documents else { completion(false) ; return }
            let collection = documents.compactMap{ Collection(firebaseDictionary: $0.data()) }
            FriendController.shared.friendsCollections.append(collection)
            for collection in collection {
                self.fetchFriendsItemImage(friendUUID: friendUUID, title: collection.title, completion: { (image) in
                    collection.collectionItemImage = image
                    collection.username = friendUsername
                    completion(true)
                })
            }
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
    
    func updateItemStatus(collection: Collection, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Collection.collectionKeys.collectionKey).document(collection.uuid)
        docRef.updateData([Collection.collectionKeys.statusKey: collection.status])
        completion(true)
    }
    
    func deleteAnItemFromFirebase(collection: Collection, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Collection.collectionKeys.collectionKey).document(collection.uuid)
        docRef.delete()
        completion(true)
    }
    
    // MARK: - Photos
    
    func savingItemImageToStorage(image: UIImage, title: String, completion: @escaping SuccessCompletion) {
        let storageRef = storage.reference()
        let image = image
        guard let currentUser = UserController.shared.currentUser?.uuid, let pictureData = image.jpegData(compressionQuality: 0.25) else { completion(false) ; return }
        let pictureRef = storageRef.child("\(currentUser)/\(title).jpeg")
        pictureRef.putData(pictureData, metadata: nil) { (_, error) in
            if let error = error {
                print("❌Error Saving: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        completion(true)
    }
    
    func savingBorrowerImageToStorage(image: UIImage, title: String, friendsName: String, completion: @escaping SuccessCompletion) {
        let storageRef = storage.reference()
        let image = image
        guard let currentUser = UserController.shared.currentUser?.uuid, let pictureData = image.jpegData(compressionQuality: 0.25) else { completion(false) ; return }
        let pictureRef = storageRef.child("\(currentUser)/\(title)\(friendsName).jpeg")
        pictureRef.putData(pictureData, metadata: nil) { (_, error) in
            if let error = error {
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        completion(true)
    }
    
    func fetchItemImage(title: String, completion: @escaping (UIImage?) -> Void) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { return }
        let gsReference = storage.reference(forURL: "gs://collectionlending.appspot.com/\(currentUser)/\(title).jpeg")
        gsReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    func fetchFriendsItemImage(friendUUID: String, title: String, completion: @escaping (UIImage?) -> Void) {
        let gsReference = storage.reference(forURL: "gs://collectionlending.appspot.com/\(friendUUID)/\(title).jpeg")
        gsReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    func fetchBorrowerImage(title: String, friendsName: String, completion: @escaping (UIImage?) -> Void) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(nil) ; return }
        let gsReference = storage.reference(forURL: "gs://collectionlending.appspot.com/\(currentUser)/\(title)\(friendsName).jpeg")
        gsReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    func deleteItemImage(title: String, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let itemRef = storage.reference(forURL: "gs://collectionlending.appspot.com/\(currentUser)/\(title).jpeg")
        itemRef.delete { (error) in
            if let error = error {
                print("❌Error delting a photo: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func deleteBorrowerImage(title: String, friendsName: String, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let gsRef = storage.reference(forURL: "gs://collectionlending.appspot.com/\(currentUser)/\(title)\(friendsName).jpeg")
        gsRef.delete { (error) in
            if let error = error {
                print("❌Error deleting Photo: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func updateFriendsArray(friend: User, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser)
        docRef.updateData([User.userKeys.friendsKey: FieldValue.arrayUnion([friend.uuid])])
        completion(true)
    }
    
    func removeFriendFromArray(friend: User, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser)
        docRef.updateData([User.userKeys.friendsKey: FieldValue.arrayRemove([friend.uuid])])
        completion(true)
    }
    
    // MARK: - Users
    func saveUser(user: User, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser)
        docRef.setData(user.dictionary)
        completion(true)
    }
    
    func fetchOneUser(completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser)
        docRef.getDocument { (document, error) in
            if let error = error {
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let document = document?.data(),
            let user = User(firebaseUser: document) else { completion(false) ; return }
            UserController.shared.currentUser = user
            completion(true)
        }
    }
    
    func fetchAllUsers(completion: @escaping SuccessCompletion) {
        firestore.collection(Collection.collectionKeys.userKey).getDocuments { (query, error) in
            if let error = error {
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let documents = query?.documents else { completion(false) ; return }
            let users = documents.compactMap { User(firebaseUser: $0.data()) }
            UserController.shared.users = users
            completion(true)
        }
    }
    
    // MARK: - Lendable
    func saveLendableToFirebase(lendable: Lendable, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Lendable.lendableKeys.lendableKey).document(lendable.uuid)
        docRef.setData(lendable.dictionary)
        completion(true)
    }
    
    func fetchLendable(completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Lendable.lendableKeys.lendableKey).getDocuments { (query, error) in
            if let error = error {
                print("❌Error: \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let documents = query?.documents else { completion(false) ; return }
            let lendables = documents.compactMap{ Lendable(firebase: $0.data()) }
            LendableController.shared.lendables = lendables
            for lendable in lendables {
                self.fetchBorrowerImage(title: lendable.title, friendsName: lendable.friendsName, completion: { (image) in
                    lendable.borrowerImage = image
                    completion(true)
                })
            }
        }
    }
    
    func updateIsReturned(lendable: Lendable, isReturned: Bool, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Lendable.lendableKeys.lendableKey).document(lendable.uuid)
        docRef.updateData([Lendable.lendableKeys.isReturnedKey: isReturned])
    }
    
    func deleteLendableFromFirebase(lendable: Lendable, completion: @escaping SuccessCompletion) {
        guard let currentUser = UserController.shared.currentUser?.uuid else { completion(false) ; return }
        let docRef = firestore.collection(Collection.collectionKeys.userKey).document(currentUser).collection(Lendable.lendableKeys.lendableKey).document(lendable.uuid)
        docRef.delete()
        completion(true)
    }
}
