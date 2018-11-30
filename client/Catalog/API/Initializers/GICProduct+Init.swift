//
//  GICProduct+Init.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension GICProduct {
    convenience init(name: String, description: String, price: Double) {
        self.init()
        self.name = name
        self.description_p = description
        self.price = price
    }
}
