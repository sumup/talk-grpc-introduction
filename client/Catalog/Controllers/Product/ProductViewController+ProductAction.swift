//
//  ProductViewController+ProductAction.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension ProductViewController {
    typealias ActionHandler = ((Bool) -> Void)?

    func retrieveProducts(_ tableView: UITableView) {
        addRandomProductButton.isEnabled = false
        refreshControl.beginRefreshing()

        grpcClient.getProducts { (products: [GICProductWithUniqueId]?, _: Error?) in
            if let products = products {
                self.products = products
                tableView.reloadData()
            }

            self.addRandomProductButton.isEnabled = true
            self.refreshControl.endRefreshing()
        }
    }

    func addProduct(_ tableView: UITableView, _ product: GICProduct, _ image: UIImage? = nil, handler: ActionHandler = nil) {
        activityIndicatorView.startAnimating()

        let request = GICCreateProductRequest(product: product, image: image)
        grpcClient.addProduct(request) { (product: GICProductWithUniqueId?, error: Error?) in
            if let product = product {
                self.products.append(product)

                let indexPath = IndexPath(item: self.products.count - 1, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }

            handler?(error == nil)

            self.activityIndicatorView.stopAnimating()
        }
    }

    func deleteProduct(_ tableView: UITableView, _ product: GICProductWithUniqueId, handler: ActionHandler = nil) {
        activityIndicatorView.startAnimating()

        let request = GICDeleteProductRequest(uniqueId: product.uniqueId)
        grpcClient.deleteProduct(request) { (error: Error?) in
            if error != nil {
                let index = self.products.firstIndex(where: { $0.uniqueId == product.uniqueId })!
                self.products.remove(at: index)

                let indexPath = IndexPath(item: index, section: 0)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }

            handler?(error == nil)

            self.activityIndicatorView.stopAnimating()
        }
    }

    func updateProduct(_ tableView: UITableView, _ product: GICProductWithUniqueId, _ image: UIImage? = nil, handler: ActionHandler = nil) {
        activityIndicatorView.startAnimating()

        let request = GICUpdateProductRequest(uniqueId: product.uniqueId, product: RandomData.randomProduct(), image: image)
        grpcClient.updateProduct(request) { (product: GICProductWithUniqueId?, error: Error?) in
            if let product = product {
                let index = self.products.firstIndex(where: { $0.uniqueId == product.uniqueId })!
                self.products[index] = product

                let indexPath = IndexPath(item: index, section: 0)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }

            handler?(error == nil)

            self.activityIndicatorView.stopAnimating()
        }
    }
}
