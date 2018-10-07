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
    private var indexPath: IndexPath?

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
                strongSelf.tableView.reloadData()
//                strongSelf.tableView.beginUpdates()
//                strongSelf.tableView.insertRows(at: insetion.map({IndexPath(row: $0, section: 0)}), with: .automatic)
//                strongSelf.tableView.deleteRows(at: deletions.map({IndexPath.init(row: $0, section: 0)}), with: .automatic)
//                strongSelf.tableView.reloadRows(at: modifications.map({IndexPath.init(row: $0, section: 0)}), with: .automatic)
//                strongSelf.tableView.endUpdates()
            
            case .error(let error):
            print(error)
            assertionFailure()
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhotos":
            if let photosCVC = segue.destination as? PhotosCollectionViewController,
                let indexPath = indexPath {
                photosCVC.setPhotosOwnerId(ownerId: friends[indexPath.row].userId)
            }
        default:
            return
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
        let getCacheImage = GetCacheImage(cacheLifeTime: GetCacheImage.avatarFriendsCacheLifeTime, url: user.avatarImage)
        let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        SetImageToRow.queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let userPhoto = UITableViewRowAction(style: .default, title: "Photos") {[weak self] (_, indexPath) in
            self?.indexPath = indexPath
            self?.performSegue(withIdentifier: "showPhotos", sender: nil)
        }
        userPhoto.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {[weak self] (_, indexPath) in
            guard let deleteUserId = self?.friends[indexPath.row].userId,
                let strongSelf = self
                else { return }
            strongSelf.friends.remove(at: indexPath.row)
            strongSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
            Service.deleteUser(userId: deleteUserId)
        }
        delete.backgroundColor = UIColor.red
        return [userPhoto, delete]
    }
}
