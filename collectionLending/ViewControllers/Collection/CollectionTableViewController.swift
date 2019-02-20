//
//  CollectionTableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class CollectionTableViewController: UITableViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var mainCollectionSearchBar: UISearchBar!
    
    // MARK: - Properties
    var resultsArray: [SearchableRecord]?
    var isSearching: Bool = false
    var collection: Collection?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Firebase.shared.fetchItemsFromFirebase { (success) in
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
                Firebase.shared.fetchOneUser(completion: { (success) in
                    if success {
                        Firebase.shared.fetchFriends(completion: { (success) in
                            if success {
                            }
                        })
                    }
                })
            }
        }
        mainCollectionSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UserController.shared.signOut { (_) in
            let welcomeVC = UIStoryboard.init(name: "Main", bundle: .main).instantiateInitialViewController() as! WelcomeViewController
            UIApplication.shared.keyWindow?.rootViewController = welcomeVC
        }
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return resultsArray?.count ?? 0
        } else {
            return CollectionController.shared.collections.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
        if isSearching == true {
            let collection = resultsArray?[indexPath.row] as? Collection
            cell.collection = collection
        } else {
            let collection = CollectionController.shared.collections[indexPath.row]
            cell.collection = collection
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "ToItemDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as? CollectionDetailViewController
            let collection = CollectionController.shared.collections[indexPath.row]
            destinationVC?.collection = collection
        }
    }
}

// MARK: - AddItemLendableViewControllerDelegate
extension CollectionTableViewController: AddItemLendableViewControllerDelegate {
    func itemStatusChange(title: String) {
        guard let collection = collection else { return }
        if title == collection.title {
            collection.status = "Out"
            Firebase.shared.updateItemStatus(collection: collection) { (_) in
            }
        }
    }
}


// MARK: - SearchBardDelegate
extension CollectionTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let collections = CollectionController.shared.collections
        let filterCollections = collections.filter{ $0.matches(searchTerm: searchText)}.compactMap{ $0 as SearchableRecord}
        resultsArray = filterCollections
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = CollectionController.shared.collections
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
