//
//  AddEditProductVC.swift
//  ArtableAdmin
//
//  Created by Fred Lefevre on 2019-07-31.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addProductPressed(_ sender: Any) {
    }
    

}
