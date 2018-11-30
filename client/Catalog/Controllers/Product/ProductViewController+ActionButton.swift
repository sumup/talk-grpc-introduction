//
//  ProductViewController+ActionButton.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension ProductViewController {
    func initActionButtons() {
        addRandomProductButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddRandomProductButtonTap)))
    }

    @objc private func onAddRandomProductButtonTap() {
        addProduct(tableView, RandomData.randomProduct(), RandomData.randomImage())
    }
}
