//
//  LogInViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationPasswordTextField: UITextField!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    @IBOutlet weak var haveAnAccountButton: UIButton!
    @IBOutlet weak var logInSignUpButton: UIButton!
    
    // MARK: - Properties
    var isLogInView: Bool?

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        updateView()
    }
    
    // MARK: - Action
    @IBAction func logInSignUpButtonTapped(_ sender: Any) {
        guard let email = emailAddressTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        if isLogInView == false {
            guard let username = usernameTextField.text, !username.isEmpty, passwordTextField.text == confirmationPasswordTextField.text else { return }
            UserController.shared.createAUser(email: email, password: password, username: username) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ToMainPageFromLogin", sender: self)
                    }
                }
            }
        } else {
            UserController.shared.signInAUser(email: email, password: password) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ToMainPageFromLogin", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func haveAnAccountButtonTapped(_ sender: Any) {
        guard let islogInView = isLogInView else { return }
        isLogInView = !islogInView
        updateView()
    }
    
    // MARK: - Setup
    func logInPage() {
        welcomeLabel.text = "Welcome Back"
        usernameTextField.isHidden = true
        confirmationPasswordTextField.isHidden = true
        logInSignUpButton.setTitle("Log In", for: .normal)
        haveAnAccountLabel.text = "Don't have an Account"
        haveAnAccountButton.setTitle("Sign Up", for: .normal)
    }
    
    func signUpPage() {
        welcomeLabel.text = "Welcome to"
        usernameTextField.isHidden = false
        confirmationPasswordTextField.isHidden = false
        logInSignUpButton.setTitle("Sign Up", for: .normal)
        haveAnAccountLabel.text = "Already have an Account"
        haveAnAccountButton.setTitle("Log In", for: .normal)
    }
    
    func updateView() {
        if isLogInView == false {
            signUpPage()
        } else {
            logInPage()
        }
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
