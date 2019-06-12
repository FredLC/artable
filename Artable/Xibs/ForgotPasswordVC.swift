//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-12.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text , email.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please enter an email address.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
                self.handleFireAuthErrors(error: error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
