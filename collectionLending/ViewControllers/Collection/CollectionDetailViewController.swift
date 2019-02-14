//
//  CollectionDetailViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit
import Photos

class CollectionDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionItemImageView: UIImageView!
    @IBOutlet weak var collectionTitleLabel: UILabel!
    @IBOutlet weak var collectionCountLabel: UILabel!
    @IBOutlet weak var collectionStatusLabel: UILabel!
    @IBOutlet weak var imageChoiceStackView: UIStackView!
    @IBOutlet weak var itemLabelStackView: UIStackView!
    @IBOutlet weak var itemEditableStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var statusPickerView: UIPickerView!
    @IBOutlet weak var countPickerView: UIPickerView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - Properties
    var collection: Collection?
    var statusList: [String] = ["Lendable", "Non-Lendable", "Out"]
    var count: Int = 1
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        isEditing = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action
    @IBAction func editButtonTapped(_ sender: Any) {
        isEditing = !isEditing
        updateItems()
        updateView()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        checkPermission()
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            importImageFromCamera()
        }
    }
    
    @IBAction func photoLibraryButtonTapped(_ sender: Any) {
        checkPermission()
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            importImageFromPhotoLibrary()
        }
    }
    
    // MARK: - Methods
    func updateView() {
        guard let collection = collection else { return }
        if isEditing {
            imageChoiceStackView.isHidden = false
            itemLabelStackView.isHidden = true
            itemEditableStackView.isHidden = false
            titleTextField.text = collection.title
            countTextField.text = "\(collection.count)"
            statusTextField.text = collection.status
            editButton.title = "Done"
        } else {
            collectionItemImageView.image = collection.collectionItemImage
            collectionTitleLabel.text = collection.title
            collectionCountLabel.text = "\(collection.count)"
            collectionStatusLabel.text = collection.status
            imageChoiceStackView.isHidden = true
            itemLabelStackView.isHidden = false
            itemEditableStackView.isHidden = true
            editButton.title = "Edit"
        }
    }
    
    func updateItems() {
        guard let collection = collection, let title = titleTextField.text, !title.isEmpty, let status = statusTextField.text, let count = countTextField.text, let image = collectionItemImageView.image else { return }
        CollectionController.shared.updateItem(collection: collection, title: title, status: status, count: Int(count) ?? 0) { (success) in
            Firebase.shared.savingItemImageToStorage(image: image, title: title, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.collection?.collectionItemImage = image
                    }
                }
            })
        }
    }
}

// MARK: - PickerViewDelegate
extension CollectionDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countPickerView {
            return 75
        } else {
            return statusList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countPickerView {
            self.view.endEditing(true)
            return "\(row + 1)"
        }
        self.view.endEditing(true)
        return statusList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countPickerView {
            count = row + 1
            self.countTextField.text = "\(count)"
            self.countPickerView.isHidden = true
        } else {
            self.statusTextField.text = self.statusList[row]
            self.statusPickerView.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == statusTextField {
            self.statusPickerView.isHidden = false
            statusTextField.endEditing(true)
        }
        if textField == countTextField {
            self.countPickerView.isHidden = false
            countTextField.endEditing(true)
        }
    }
}

// MARK: - Photo Picker delegate
extension CollectionDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func importImageFromCamera() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.camera
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func importImageFromPhotoLibrary() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            collectionItemImageView.image = image
        } else {
            print("❌🛰Error getting image from photo Library or camera")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                print("status is \(newStatus)")
            }
        case .restricted:
            print("User do not have access to photo album")
        case .denied:
            print("User has denied the permission.")
        }
    }
    
}

// MARK: - TextField Delegate
extension CollectionDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
