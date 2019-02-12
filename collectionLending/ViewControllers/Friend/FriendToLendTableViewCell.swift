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
    
    // MARK: - Setup
    func updateView() {
        
    }
}
