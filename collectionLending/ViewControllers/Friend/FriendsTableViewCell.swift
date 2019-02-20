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
        delegate?.cellButtonTapped(self)
        changeBoxImage()
    }
    
   
    // MARK: - Setup
    func updateViews() {
        guard let friend = friend, let user = UserController.shared.currentUser else { return }
        usersNameLabel.text = friend.username
        if user.friends.contains(friend.uuid) {
            addFriendButton.setImage(UIImage(named: "checkmark"), for: .normal)
        } else {
            addFriendButton.setImage(UIImage(named: "circle"), for: .normal)
        }
    }
    
    func changeBoxImage() {
        guard let friend = friend, let user = UserController.shared.currentUser else { return }
        if !user.friends.contains(friend.uuid) {
            addFriendButton.setImage(UIImage(named: "circle"), for: .normal)
            FriendController.shared.addToFriendsList(uuid: friend.uuid, username: friend.username) { (success) in
                if success {
                    Firebase.shared.fetchItemForFriend(friendUsername: friend.username, friendUUID: friend.uuid, completion: { (_) in
                    })
                }
            }
        } else {
            addFriendButton.setImage(UIImage(named: "checkmark"), for: .normal)
            FriendController.shared.removeFriendFromList(friend: friend) { (success) in
                if success {
                    FriendController.shared.friendsCollections = []
                    Firebase.shared.fetchItemForFriend(friendUsername: friend.username, friendUUID: friend.uuid, completion: { (_) in
                    })
                }
            }
        }
    }
}
