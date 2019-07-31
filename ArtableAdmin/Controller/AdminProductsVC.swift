//
//  AdminProductsVC.swift
//  ArtableAdmin
//
//  Created by Fred Lefevre on 2019-07-29.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let addProductButton = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(addProduct))
        navigationItem.setRightBarButtonItems([editCategoryButton, addProductButton], animated: false)
        
    }
  
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.toEditCategory, sender: self)
    }
    
    @objc func addProduct() {
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toAddEditProduct {
            if let destination = segue.destination as? AddEditProductVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.toEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }

}
