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
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
