//
//  ProductDetailVC.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-07-29.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var blurredBackground: UIVisualEffectView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTitle.text = product.name
        productDescription.text = product.productDescription
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        blurredBackground.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCartPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
