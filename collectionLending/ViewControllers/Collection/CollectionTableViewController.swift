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
    var collection: Collection?
    var user: User?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = user?.username
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Firebase.shared.fetchItemsFromFirebase { (success) in
            if success {
                Firebase.shared.fetchOneUser(completion: { (success) in
                    if success {
                        Firebase.shared.fetchFriends(completion: { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    self.tableView.reloadData()
                                }
                                
                            }
                        })
                    }
                })
            }
        }
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
        return CollectionController.shared.collections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
        let collection = CollectionController.shared.collections[indexPath.row]
        cell.collection = collection
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

extension CollectionTableViewController: UISearchBarDelegate {
    
}
