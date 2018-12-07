//
//  GICCreateProductRequest+Init.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension GICCreateProductRequest {
    convenience init(product: GICProduct, image: UIImage?) {
        self.init()
        self.product = product
        self.image.image.data_p = image?.pngData()
    }
}
