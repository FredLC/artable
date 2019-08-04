//
//  UserService.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-08-04.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

let UserService = _UserService()

final class _UserService {
    
    // Variables
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var favoritesListener: ListenerRegistration? = nil
    var usersListener: ListenerRegistration? = nil
    
    var isGuest: Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        let userRef = db.collection("users").document(authUser.uid)
        usersListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
            print(self.user)
        })
        
        let favoritesRef = userRef.collection("favorites")
        favoritesListener = favoritesRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func favoriteSelected(product: Product) {
        let favoritesRef = db.collection("users").document(user.id).collection("favorites")
        if favorites.contains(product) {
            favorites.removeAll(where: { $0 == product})
            favoritesRef.document(product.id).delete()
        } else {
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favoritesRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser() {
        usersListener?.remove()
        usersListener = nil
        favoritesListener?.remove()
        favoritesListener = nil
        user = User()
    }
}
