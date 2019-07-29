//
//  AddEditCategoryVC.swift
//  ArtableAdmin
//
//  Created by Fred Lefevre on 2019-07-29.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {
    
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    func uploadImage() {
        guard let image = categoryImage.image,
            let categoryName = categoryText.text, categoryName.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please enter a name and select and image")
                return
        }
        // 1. Transform image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        // 2. Create a storage image reference -> A location in Firestorage for it to be stored.
        let imageReference = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        // 3. Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        // 4. Upload data
        imageReference.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload data")
                return
            }
            
            // 5. Once data is uploaded, retrieve download url
            imageReference.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, message: "Unable to retrieve download url")
                    return
                }
                guard let url = url else { return }
                // 6. Upload new Category document to the Firestore categories collection
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var category = Category.init(name: categoryText.text!, id: "", imageUrl: url, timeStamp: Timestamp())
        docRef = Firestore.firestore().collection("categories").document()
        category.id = docRef.documentID
        
        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload new category to Firestore")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addCategoryPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImage()
    }
    
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", message: message)
        self.activityIndicator.stopAnimating()
    }
    
}

extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
