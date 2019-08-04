//
//  AddEditProductVC.swift
//  ArtableAdmin
//
//  Created by Fred Lefevre on 2019-07-31.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddEditProductVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var productPriceText: UITextField!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addProductButton: RoundedButton!
    
    // Variables
    var selectedCategory: Category!
    var productToEdit: Product?
    
    var name = ""
    var price = 0.0
    var productDescriptionText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            productNameText.text = product.name
            productPriceText.text = String(product.price)
            productDescription.text = product.productDescription
            
            if let url = URL(string: product.imageUrl) {
                productImage.contentMode = .scaleAspectFill
                productImage.kf.setImage(with: url)
            }
            addProductButton.setTitle("Save Changes", for: .normal)
        }
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    func uploadImage() {
        guard let image = productImage.image,
            let productName = productNameText.text, productName.isNotEmpty,
            let productPriceString = productPriceText.text, productPriceString.isNotEmpty,
            let productPrice = Double(productPriceString),
            let productDescription = productDescription.text, productDescription.isNotEmpty else {
                simpleAlert(title: "Error", message: "Product image and name required")
                return
        }
        
        self.name = productName
        self.price = productPrice
        self.productDescriptionText = productDescription
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload data")
                return
            }
        }
        imageRef.downloadURL { (url, error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to retrieve download url")
                return
            }
            guard let url = url else { return }
            self.uploadDocument(url: url.absoluteString)
        }
        
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var product = Product.init(name: name, id: "", category: selectedCategory.id, price: price, productDescription: productDescriptionText, imageUrl: url)
        
        if let productToEdit = productToEdit {
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload new product to Firestore")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", message: message)
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func addProductPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImage()
    }
    

}

extension AddEditProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImage.contentMode = .scaleAspectFill
        productImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
