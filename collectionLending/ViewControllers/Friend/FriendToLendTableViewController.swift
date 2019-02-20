//
//  FriendToLendTableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/11/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class FriendToLendTableViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var friendsItemSearchBar: UISearchBar!
    
    // MARK: - Properties
    var resultsArray: [SearchableRecord]?
    var isSearching: Bool = false
    var friend: User?
    
    // MARK: - ViewLoadCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsItemSearchBar.delegate = self
        fetchFriendsItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Methods
    func fetchFriendsItems() {
        Firebase.shared.fetchItemsForFriends { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return FriendController.shared.friendsCollections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let friendCollection =  FriendController.shared.friendsCollections[section].first
        return friendCollection?.title
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return resultsArray?.count ?? 0
        } else {
            return FriendController.shared.friendsCollections[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendToLendCell", for: indexPath) as! FriendToLendTableViewCell
        if isSearching == true {
            let collection = resultsArray?[indexPath.row] as? Collection
            cell.collection = collection
        } else {
            let friendCollections = FriendController.shared.friendsCollections[indexPath.section]
            let collection = friendCollections[indexPath.row]
            cell.collection = collection
        }
        return cell
    }
}

// MARK: - SearchBarDelegate
extension FriendToLendTableViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let friendsCollection = FriendController.shared.friendsCollections
//        let filterFriendsCollection = friendsCollection.filter{ $0.matches(searchTerm: searchText)}.compactMap{ $0 as SearchableRecord}
//        resultsArray = filterFriendsCollection
//        tableView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        resultsArray = FriendController.shared.friendsCollections
//        tableView.reloadData()
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}
