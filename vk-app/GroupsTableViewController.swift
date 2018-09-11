//
//  GroupsTableViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 27/08/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 55
        
        Service.getGroups(userId: Service.getUserId())
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
