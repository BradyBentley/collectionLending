//
//  ItemsLendableTableViewCell.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class ItemsLendableTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var borrowerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var returnedButton: UIButton!
    @IBOutlet weak var borrowerNameLabel: UILabel!
    
    
    // MARK: - Properties
    var lendable: Lendable? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Action
    
    @IBAction func returnedButtonTapped(_ sender: Any) {
        guard let lendable = lendable else { return }
        lendable.isReturned = !lendable.isReturned
        updateView()
    }
    
    
    // MARK: - Setup
    func updateView() {
        guard let lendable = lendable else { return }
        borrowerImageView.image = lendable.borrowerImage
        dueDateLabel.text = lendable.dueDate.asPrettyString
        titleLabel.text = lendable.title
        borrowerNameLabel.text = lendable.friendsName
        if lendable.isReturned {
            returnedButton.setImage(UIImage(named: "checkmark"), for: .normal)
            Firebase.shared.updateIsReturned(lendable: lendable, isReturned: lendable.isReturned) { (_) in
            }
        } else {
            returnedButton.setImage(UIImage(named: "circle"), for: .normal)
            Firebase.shared.updateIsReturned(lendable: lendable, isReturned: lendable.isReturned) { (_) in
            }
            
        }
    }
    
}
