//
//  LoginVC.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-07.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text , email.isNotEmpty ,
            let password = passwordTextField.text, password.isNotEmpty else { return }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                debugPrint(error)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            print("successfully logged in user")
        }
    }
    
    @IBAction func guestButtonPressed(_ sender: Any) {
    }
    
}
