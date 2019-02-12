//
//  ItemDetailLendableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class ItemDetailLendableViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var borrowerImageView: UIImageView!
    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var returnedButton: UIButton!
    
    // MARK: - Properties
    var lendable: Lendable?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func returnedButtonTapped(_ sender: Any) {
        guard let lendable = lendable else { return }
        lendable.isReturned = !lendable.isReturned
        updateViews()
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let lendable = lendable else { return }
        borrowerImageView.image = lendable.borrowerImage
        friendsNameLabel.text = lendable.friendsName
        dueDateLabel.text = lendable.dueDate.asPrettyString
        titleLabel.text = lendable.title
        if lendable.isReturned {
            returnedButton.setImage(UIImage(named: "checkmark"), for: .normal)
        } else {
            returnedButton.setImage(UIImage(named: "circle"), for: .normal)
        }
    }
}
