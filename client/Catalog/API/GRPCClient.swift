//
//  GRPCClient.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

class GRPCClient {
    typealias GetProductsHandler = (([GICProductWithUniqueId]?, Error?) -> Void)?
    typealias AddProductHandler = ((GICProductWithUniqueId?, Error?) -> Void)?
    typealias DeleteProductHandler = ((Error?) -> Void)?
    typealias UpdateProductHandler = ((GICProductWithUniqueId?, Error?) -> Void)?

    private let productService: GICProductService

    init() {
        GRPCCall.useInsecureConnections(forHost: "localhost:6666")
        productService = GICProductService.init(host: "localhost:6666")
    }

    func getProducts(handler: GetProductsHandler) {
        let request = GICGetProductsRequest.init()
        productService.getProductsWith(request) { (response: GICGetProductsResponse?, error: Error?) in
            if error != nil {
                handler?(nil, error)
            } else {
                handler?(response?.productArray as? [GICProductWithUniqueId] ?? [], nil)
            }
        }
    }

    func addProduct(_ request: GICCreateProductRequest, handler: AddProductHandler) {
        productService.createProduct(with: request, handler: { (response: GICCreateProductResponse?, error: Error?) in
            handler?(response?.product, error)
        })
    }

    func updateProduct(_ request: GICUpdateProductRequest, handler: UpdateProductHandler) {
        productService.updateProduct(with: request, handler: { (response: GICUpdateProductResponse?, error: Error?) in
            handler?(response?.product, error)
        })
    }

    func deleteProduct(_ request: GICDeleteProductRequest, handler: DeleteProductHandler) {
        productService.deleteProduct(with: request, handler: { (_: GICDeleteProductResponse?, error: Error?) in
            handler?(error)
        })
    }
}
