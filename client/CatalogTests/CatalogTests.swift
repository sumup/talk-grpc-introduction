//
//  CatalogTests.swift
//  CatalogTests
//
//  Created by Stanislav Zahariev on 6.12.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

@testable import Catalog
import XCTest

class CatalogTests: XCTestCase {
    func testProductInits() {
        let emptyProduct = GICProduct()
        let regularProduct = GICProduct(name: "test-name", description: "test-description", price: 1)

        assertAllPropertiesUnequal(lhs: emptyProduct, rhs: regularProduct)
    }
}
