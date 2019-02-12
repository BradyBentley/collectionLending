//
//  ItemsLendableTableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class ItemsLendableTableViewController: UITableViewController {
    
    var lendable: Lendable?

    override func viewDidLoad() {
        super.viewDidLoad()
        Firebase.shared.fetchLendable { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LendableController.shared.lendables.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsLent", for: indexPath) as! ItemsLendableTableViewCell
        let lendable = LendableController.shared.lendables[indexPath.row]
        cell.lendable = lendable
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "ToItemsLentDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as? ItemDetailLendableViewController
            let lendable = LendableController.shared.lendables[indexPath.row]
            destinationVC?.lendable = lendable
        }
    }
}
