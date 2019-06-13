//
//  Product.swift
//  Artable
//
//  Created by Fred Lefevre on 2019-06-13.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageUrl: String
    var timeStamp: Timestamp
    var stock: Int
    var favorite: Bool
}
