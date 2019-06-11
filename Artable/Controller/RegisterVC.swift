//
//  RegisterVC.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-07.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text , !email.isEmpty ,
              let username = usernameTextField.text , !username.isEmpty ,
              let password = passwordTextField.text , !password.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                debugPrint(error)
                return
            }
            
            print("successfully registered user")
        }
    }
    
}
