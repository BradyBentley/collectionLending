//
//  CollectionDetailViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionItemImageView: UIImageView!
    @IBOutlet weak var collectionTitleLabel: UILabel!
    @IBOutlet weak var collectionCountLabel: UILabel!
    @IBOutlet weak var collectionStatusLabel: UILabel!
    // MARK: - Properties
    var collection: Collection?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Action
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Methods
    func updateView() {
        guard let collection = collection else { return }
        collectionItemImageView.image = collection.collectionItemImage
        collectionTitleLabel.text = collection.title
        collectionCountLabel.text = "\(collection.count)"
        collectionStatusLabel.text = collection.status
    }
}
