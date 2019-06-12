//
//  ViewController.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-06.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    
    @IBOutlet weak var loginLogoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = Auth.auth().currentUser {
            loginLogoutButton.title = "Logout"
        } else {
            loginLogoutButton.title = "Login"
        }
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func loginLogoutButtonPressed(_ sender: Any) {
        
        if let _ = Auth.auth().currentUser {
            do {
                try Auth.auth().signOut()
                presentLoginController()
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            presentLoginController()
        }
        
    }
}

