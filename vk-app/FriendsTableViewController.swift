//
//  FriendsTableViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 27/08/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    private var friends: [User] = []
    private var tokenFriends: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 55
        
        Service.getFriends(userId: Service.getUserId())
        pairTableFriendsAndData()
    }
    
    private func pairTableFriendsAndData() {
        guard let friends = DataWorker.loadUserData()
            else { return }
        self.friends = Array(friends)
        tokenFriends = friends.observe {[weak self] (changes) in
            guard let strongSelf = self
                else { return }
            switch changes {
            case .initial:
                strongSelf.tableView.reloadData()
            
            case let .update(results, deletions, insetion, modifications):
            strongSelf.friends = Array(results)
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: insetion.map({IndexPath(row: $0, section: 0)}), with: .automatic)
            strongSelf.tableView.deleteRows(at: deletions.map({IndexPath.init(row: $0, section: 0)}), with: .automatic)
            strongSelf.tableView.reloadRows(at: modifications.map({IndexPath.init(row: $0, section: 0)}), with: .automatic)
            strongSelf.tableView.endUpdates()
            
            case .error(let error):
            print(error)
            assertionFailure()
                
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendTableViewCell
        let user = friends[indexPath.row]
        cell.setName(text: user.name)
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
