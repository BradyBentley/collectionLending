//
//  FriendsTableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/11/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var findAFriendSearchBar: UISearchBar!
    
    
    // MARK: - Properties
    var resultArray: [SearchableRecord]?
    var isSearching: Bool = false
    var user: User?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Firebase.shared.fetchAllUsers { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
        findAFriendSearchBar.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return resultArray?.count ?? 0
        } else {
            return UserController.shared.users.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        if isSearching == true {
            let user = resultArray?[indexPath.row] as? User
            cell.friend = user
        } else {
            let user = UserController.shared.users[indexPath.row]
            cell.friend = user
        }
        cell.delegate = self
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension FriendsTableViewController: FriendsTableViewCellDelegate {
    func cellButtonTapped(_ cell: FriendsTableViewCell) {
        tableView.reloadData()
    }
}

// MARK: - SearchBarDelegate
extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let friends = UserController.shared.users
        let filterFriends = friends.filter{ $0.matches(searchTerm: searchText)}.compactMap{ $0 as SearchableRecord}
        resultArray = filterFriends
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultArray = UserController.shared.users
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}

