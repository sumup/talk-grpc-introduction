//
//  ProductViewController+TableView.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    func initTableView() {
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    @objc private func refreshTableViewData(sender: UIRefreshControl) {
        retrieveProducts(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.deleteProduct(tableView, self.products[indexPath.item], handler: completionHandler)
        }

        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            self.updateProduct(tableView, self.products[indexPath.item], RandomData.randomImage(), handler: completionHandler)
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [edit, delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
        let product = products[indexPath.item];
        cell.display(product)
        return cell
    }
}
