//
//  AddItemLendableViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit
import Photos

protocol AddItemLendableViewControllerDelegate: class {
    func itemStatusChange(title: String)
}

class AddItemLendableViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titlePickerView: UIPickerView!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var borrowerImageView: UIImageView!
    @IBOutlet weak var friendsNameTextField: UITextField!
    
    // MARK: - Properties
    weak var delegate: AddItemLendableViewControllerDelegate?
    var lendable: Lendable?
    var movieTitles: [String] = []
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        for collection in CollectionController.shared.collections {
            movieTitles.append(collection.title)
        }
        let imagePickerController = UINavigationController()
        imagePickerController.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, let image = borrowerImageView.image, let friendsName = friendsNameTextField.text else { return }
        let dueDate = dueDatePickerView.date
//        delegate?.itemStatusChange(title: title)
        LendableController.shared.createLendable(friendsName: friendsName, title: title, dueDate: dueDate, image: image) { (success) in
            Firebase.shared.savingBorrowerImageToStorage(image: image, title: title, friendsName: friendsName, completion: { (success) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        checkPermission()
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            importImageFromCamera()
        }
    }
    
    @IBAction func photoLibraryButtonTapped(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            importImageFromPhotoLibrary()            
        }
    }
}
// MARK: - PickerView
extension AddItemLendableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return movieTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return movieTitles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.titleTextField.text = self.movieTitles[row]
        self.titlePickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleTextField {
            self.titlePickerView.isHidden = false
            titleTextField.endEditing(true)
        }
    }
}

// MARK: - TextField Delegate
extension AddItemLendableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Photo Picker Delegate
extension AddItemLendableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            borrowerImageView.image = image
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
