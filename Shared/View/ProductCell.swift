//
//  ProductCell.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-13.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product) {
        productName.text = product.name
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: "placeholder")
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
    }
    
}
