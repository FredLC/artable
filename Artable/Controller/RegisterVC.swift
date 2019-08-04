//
//  RegisterVC.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-07.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordCheckImage: UIImageView!
    @IBOutlet weak var confirmPasswordCheckImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        guard let passwordText = passwordTextField.text else { return }
        
        if textfield == confirmPasswordTextField {
            passwordCheckImage.isHidden = false
            confirmPasswordCheckImage.isHidden = false
        } else {
            if passwordText.isEmpty {
                passwordCheckImage.isHidden = true
                confirmPasswordCheckImage.isHidden = true
            }
        }
        
        if passwordTextField.text == confirmPasswordTextField.text {
            passwordCheckImage.image = UIImage(named: AppImages.GreenCheck)
            confirmPasswordCheckImage.image = UIImage(named: AppImages.GreenCheck)
        } else {
            passwordCheckImage.image = UIImage(named: AppImages.RedCheck)
            confirmPasswordCheckImage.image = UIImage(named: AppImages.RedCheck)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text , email.isNotEmpty ,
              let username = usernameTextField.text , username.isNotEmpty ,
              let password = passwordTextField.text , password.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please fill out all fields.")
                return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text , confirmPassword == password else {
            simpleAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        activityIndicator.startAnimating()
        
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                debugPrint(error)
//                Auth.auth().handleFireAuthErrors(error: error, vc: self)
//                self.activityIndicator.stopAnimating()
//                return
//            }
//            guard let fireUser = result?.user else { return }
//            let artableUser = User.init(id: fireUser.uid, email: email, username: username, stripeId: "")
//            // Upload to Firestore
//            self.createFirestoreUser(user: artableUser)
//        }
        
        guard let authUser = Auth.auth().currentUser else { return }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthErrors(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }

            guard let fireUser = result?.user else { return }
            let artableUser = User.init(id: fireUser.uid, email: email, username: username, stripeId: "")
            // Upload to Firestore
            self.createFirestoreUser(user: artableUser)
        }
        
    }
    
    func createFirestoreUser(user: User) {
        // 1. Create doc reference
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        // 2. Create model data
        let data = User.modelToData(user: user)
        // 3. Upload to Firestore
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthErrors(error: error, vc: self)
                debugPrint("Error signing in: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
}
