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
    
    
    // MARK: - Properties
    var lendable: Lendable? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Setup
    func updateView() {
        guard let lendable = lendable else { return }
        borrowerImageView.image = lendable.borrowerImage
        dueDateLabel.text = lendable.dueDate.asPrettyString
        titleLabel.text = lendable.title
        if lendable.isReturned {
            returnedButton.setImage(UIImage(named: "checkmark"), for: .normal)
        } else {
            returnedButton.setImage(UIImage(named: "circle"), for: .normal)
            
        }
    }
    
}
