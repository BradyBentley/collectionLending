//
//  CollectionTableViewCell.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    // MARK: - Properties
    var collection: Collection?{
        didSet{
            updateView()
        }
    }
    
    // MARK: - Setup
    func updateView() {
        guard let collection = collection else { return }
        itemImageView.image = collection.collectionItemImage
        itemTitleLabel.text = collection.title
    }
}
