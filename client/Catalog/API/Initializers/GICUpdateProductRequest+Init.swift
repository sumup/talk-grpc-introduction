//
//  GICUpdateProductRequest+Init.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension GICUpdateProductRequest {
    convenience init(uniqueId: String, product: GICProduct?, image: UIImage?) {
        self.init()
        self.uniqueId = uniqueId
        self.product = product
        self.image.image.data_p = image?.pngData()
    }
}
