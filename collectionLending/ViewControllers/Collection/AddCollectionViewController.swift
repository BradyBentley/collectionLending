//
//  AddCollectionViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit
import Photos

class AddCollectionViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var collectionTitleTextField: UITextField!
    @IBOutlet weak var collectionCountTextField: UITextField!
    @IBOutlet weak var collectionCountPickerView: UIPickerView!
    @IBOutlet weak var collectionStatusTextField: UITextField!
    @IBOutlet weak var collectionStatusPickerView: UIPickerView!
    @IBOutlet weak var collectionStatusStackView: UIStackView!
    // MARK: - Properties
    var collection: Collection?
    var statusList: [String] = ["Lendable", "Non-Lendable", "Out"]
    var count: Int = 1
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func cameraButtonTapped(_ sender: Any) {
        checkPermission()
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            importImageFromCamera()
        }
    }
    
    @IBAction func photoLibraryButtonTapped(_ sender: Any) {
        checkPermission()
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            importImageFromPhotoLibrary()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = collectionTitleTextField.text, !title.isEmpty, let count = collectionCountTextField.text, let status = collectionStatusTextField.text, let image = collectionImageView.image else { return }
        collection?.collectionItemImage = image
        CollectionController.shared.createAnItem(title: title, status: status, image: image, count: Int(count) ?? 0) { (success) in
            if success {
                Firebase.shared.savingItemImageToStorage(image: image, title: title, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            }
        }
    }
}

// MARK: - PickerViews
extension AddCollectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == collectionCountPickerView {
            return 75
        } else {
            return statusList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == collectionCountPickerView {
            self.view.endEditing(true)
            return "\(row + 1)"
        } else {
            self.view.endEditing(true)
            return statusList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == collectionCountPickerView {
            count = row + 1
            self.collectionCountTextField.text = "\(count)"
            self.collectionCountPickerView.isHidden = true
        } else {
            self.collectionStatusTextField.text = self.statusList[row]
            self.collectionStatusPickerView.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == collectionStatusTextField {
            self.collectionStatusPickerView.isHidden = false
            collectionStatusTextField.endEditing(true)
        }
        if textField == collectionCountTextField {
            self.collectionCountPickerView.isHidden = false
            collectionCountTextField.endEditing(true)
        }
    }
}

// MARK: - Photo picker delegate
extension AddCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            collectionImageView.image = image
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
extension AddCollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
