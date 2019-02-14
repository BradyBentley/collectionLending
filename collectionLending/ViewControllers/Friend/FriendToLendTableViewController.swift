//
//  FriendToLendTableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/11/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class FriendToLendTableViewController: UITableViewController {
    // MARK: - Properties
    var friend: User?
    
    // MARK: - ViewLoadCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriendsItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFriendsItems()
        
    }
    
    // MARK: - Methods
    func fetchFriendsItems() {
        Firebase.shared.fetchItemsForFriends { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.friendsCollections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendToLendCell", for: indexPath) as! FriendToLendTableViewCell
        let collection = FriendController.shared.friendsCollections[indexPath.row]
        cell.collection = collection
        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
