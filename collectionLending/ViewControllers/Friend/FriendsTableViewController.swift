//
//  FriendsTableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/11/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    // MARK: - Properties
    var user: User?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Firebase.shared.fetchAllUsers { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        let user = UserController.shared.users[indexPath.row]
        cell.friend = user
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

// MARK: - FriendsTableViewCellDelegate
extension FriendsTableViewController: FriendsTableViewCellDelegate {
    func cellButtonTapped(_ cell: FriendsTableViewCell) {
        guard let user = cell.friend, let uuid = cell.friend?.uuid, let username = cell.friend?.username else { return }
        if cell.isFriend {
            FriendController.shared.addToFriendsList(uuid: uuid, username: username) { (_) in
            }
        } else {
            FriendController.shared.removeFriendFromList(user: user) { (_) in
            }
        }
    }
    
    
}
