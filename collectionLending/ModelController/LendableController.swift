//
//  LendableController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class LendableController {
    // MARK: - Properties
    static let shared = LendableController()
    var lendables: [Lendable] = []
    
    // MARK: - CRUD
    func createLendable(friendsName: String, title: String, dueDate: Date, image: UIImage, completion: @escaping SuccessCompletion) {
        let newLendable = Lendable(friendsName: friendsName, dueDate: dueDate, borrowerImage: image, title: title)
        lendables.append(newLendable)
        Firebase.shared.saveLendableToFirebase(lendable: newLendable) { (_) in
        }
        completion(true)
    }
    
    func deleteLendable(lendable: Lendable, completion: @escaping SuccessCompletion) {
        guard let index = lendables.index(of: lendable) else { completion(false) ; return }
        lendables.remove(at: index)
        Firebase.shared.deleteLendableFromFirebase(lendable: lendable) { (_) in
        }
        completion(true)
    }
}
