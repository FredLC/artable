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
        let forgotPasswordVC = ForgotPasswordVC()
        forgotPasswordVC.modalPresentationStyle = .overCurrentContext
        present(forgotPasswordVC, animated: true, completion: nil)
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text , email.isNotEmpty ,
            let password = passwordTextField.text, password.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please fill out all fields.")
                return
        }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthErrors(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func guestButtonPressed(_ sender: Any) {
    }
    
}
