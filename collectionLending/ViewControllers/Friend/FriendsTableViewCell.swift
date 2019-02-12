//
//  FriendsTableViewCell.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/11/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

protocol FriendsTableViewCellDelegate: class {
    func cellButtonTapped(_ cell: FriendsTableViewCell)
}

class FriendsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: FriendsTableViewCellDelegate?
    var friend: User? {
        didSet{
            updateViews()
        }
    }
    var isFriend: Bool = false
    
    // MARK: - Actions
    @IBAction func addFriendButtonTapped(_ sender: Any) {
        isFriend = !isFriend
        delegate?.cellButtonTapped(self)
        updateViews()
    }
    
   
    // MARK: - Setup
    func updateViews() {
        guard let friend = friend else { return }
        usersNameLabel.text = friend.username
        if isFriend {
            addFriendButton.setImage(UIImage(named: "checkmark"), for: .normal)
        } else {
            addFriendButton.setImage(UIImage(named: "circle"), for: .normal)
        }
    }

}
