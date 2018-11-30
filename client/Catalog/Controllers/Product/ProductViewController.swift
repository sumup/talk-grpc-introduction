//
//  ProductViewController.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 28.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addRandomProductButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let refreshControl = UIRefreshControl()

    var products: [GICProductWithUniqueId] = []
    let grpcClient = GRPCClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initActionButtons()

        retrieveProducts(tableView)
    }
}
