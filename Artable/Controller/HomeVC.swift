//
//  ViewController.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-06.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginLogoutButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories = [Category]()
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error)
                    Auth.auth().handleFireAuthErrors(error: error, vc: self)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        fetchDocument()
        fetchCollection()
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginLogoutButton.title = "Logout"
        } else {
            loginLogoutButton.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    func fetchDocument() {
        let docRef = db.collection("categories").document("1dvtH7X3T1BcXXnvvwgd")
        
        docRef.addSnapshotListener { (snap, error) in
            self.categories.removeAll()
            guard let data = snap?.data() else { return }
            let newCategory = Category.init(data: data)
            self.categories.append(newCategory)
            self.collectionView.reloadData()
        }
        
//        docRef.getDocument { (snap, error) in
//            guard let data = snap?.data() else { return }
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
    }
    
    func fetchCollection() {
        let collectionRef = db.collection("categories")
        
        listener = collectionRef.addSnapshotListener { (snap, error) in
            guard let documents = snap?.documents else { return }
            self.categories.removeAll()
            for document in documents {
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
        }
        
//        collectionRef.getDocuments { (snap, error) in
//            guard let documents = snap?.documents else { return }
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
    }

    @IBAction func loginLogoutButtonPressed(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error)
                        Auth.auth().handleFireAuthErrors(error: error, vc: self)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthErrors(error: error, vc: self)
            }
        }
        
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.toProductsVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toProductsVC {
            if let productsVC = segue.destination as? ProductsVC {
                productsVC.category = selectedCategory
            }
        }
    }
    
}

