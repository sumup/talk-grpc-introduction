//
//  ProductCell.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 28.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

class ProductCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func display(_ product: GICProductWithUniqueId) {
        nameLabel.text = product.product.name
        descriptionLabel.text = product.product.description_p
        priceLabel.text = String(format: "%f", product.product.price)
        productImageView.image = UIImage(data: product.image.data_p)
    }
}
