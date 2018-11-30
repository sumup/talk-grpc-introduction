//
//  GICDeleteProductRequest+Init.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension GICDeleteProductRequest {
    convenience init(uniqueId: String) {
        self.init()
        self.uniqueId = uniqueId
    }
}
