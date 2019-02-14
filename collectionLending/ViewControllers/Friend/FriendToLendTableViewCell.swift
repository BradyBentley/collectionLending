//
//  FriendToLendTableViewCell.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class FriendToLendTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var friendItemImageView: UIImageView!
    @IBOutlet weak var friendTitleLabel: UILabel!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendStatusLabel: UILabel!
    
    
    // MARK: - Properties
    var friend: User? {
        didSet {
            updateView()
        }
    }
    var collection: Collection? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Setup
    func updateView() {
        guard let collection = collection else { return }
        friendItemImageView.image = collection.collectionItemImage
        friendTitleLabel.text = collection.title
        friendStatusLabel.text = collection.status
    }    
}
