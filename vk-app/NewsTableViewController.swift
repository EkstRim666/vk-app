//
//  NewsTableViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 10/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.getNews()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
