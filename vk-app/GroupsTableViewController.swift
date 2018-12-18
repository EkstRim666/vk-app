//
//  GroupsTableViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 27/08/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var tokenGroup: NotificationToken?
    private var groups: [Group] = []
    private var searchGroup: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.rowHeight = 55
        
        Service.getGroups(userId: Service.getUserId())
        pairTableGroupAndData(Service.getUserId())
    }
    
    private func pairTableGroupAndData(_ ownerId: Int) {
        guard let groups = DataWorker.loadGroupData(ownerId: ownerId)
            else { return }
        self.groups = Array(groups)
        tokenGroup = groups.observe {[weak self] (changes) in
            guard let `self` = self
                else { return }
            switch changes {
            case .initial:
                self.tableView.reloadData()
                
            case let .update(results, deletions, insetion, modifications):
                self.groups = Array(results)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insetion.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.deleteRows(at: deletions.map({IndexPath.init(row: $0, section: 0)}), with: .automatic)
                self.tableView.reloadRows(at: modifications.map({IndexPath.init(row: $0, section: 0)}), with: .automatic)
                self.tableView.endUpdates()
                
            case .error(let error):
                assertionFailure("\(error)")
                
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "group", for: indexPath) as! GroupTableViewCell
        if searchGroup.isEmpty || searchBar.text == "" {
            let group = groups[indexPath.row]
            cell.setName(text: group.name)
            let getCacheImage = GetCacheImage(cacheLifeTime: GetCacheImage.avatarGroupsCacheLifeTime, url: group.avatarImage)
            let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            SetImageToRow.queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
        } else {
            let group = searchGroup[indexPath.row]
            cell.setName(text: group.name)
            cell.avatar.downloadedFrom(link: group.avatarImage)
        }
        return cell
    }
}

extension GroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            Service.searchGroupName(searchText) { [weak self] searchGroup in
                self?.searchGroup = searchGroup
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        } else {
            self.searchGroup.removeAll()
            self.tableView.reloadData()
        }
    }
}
