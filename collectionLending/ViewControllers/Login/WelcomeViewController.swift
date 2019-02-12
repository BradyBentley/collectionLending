//
//  WelcomeViewController.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/7/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let uuid = user.uid
                UserController.shared.currentUser = User(uuid: uuid)
                Firebase.shared.fetchOneUser(completion: { (_) in
                })
                self.performSegue(withIdentifier: "ToMainPageFromWelcomePage", sender: self)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? LogInViewController
        if segue.identifier == "ToLogInView" {
            let isLogInView = true
            destinationVC?.isLogInView = isLogInView
        }
        if segue.identifier == "ToSignUpView" {
            let isLogInView = false
            destinationVC?.isLogInView = isLogInView
        }
    }
}
