//
//  MessagesViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 08/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit
import RealmSwift

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var user: User?
    private var messages: [Message] = []
    private var tokenMessage: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 30
        
        guard let user = user
            else { return }
        Service.getMessage(userId: user.userId)
        pairTableMessageAndData()
        
        friendName.text = user.name
        let getCacheImage = GetCacheImage(cacheLifeTime: GetCacheImage.avatarFriendsCacheLifeTime, url: user.avatarImage)
        getCacheImage.completionBlock = {[weak self] in
            OperationQueue.main.addOperation {
                self?.avatar.image = getCacheImage.outputImage
            }
        }
        SetImageToRow.queue.addOperation(getCacheImage)
    }
    
    func setUserFromMessagesVC(user: User) {
        self.user = user
    }
    
    private func pairTableMessageAndData() {
        guard let user = user,
            let messages = DataWorker.loadMessagesData(ownerId: user.userId)
            else { return }
        self.messages = Array(messages)
        tokenMessage = messages.observe {[weak self] (changes) in
            guard let `self` = self else { return }
            switch changes {
            case .initial:
                self.tableView.reloadData()
                
            case let .update(results, deletions, insetion, modifications):
                self.messages = Array(results)
           self.tableView.reloadData()
                
            case .error(let error):
                assertionFailure("\(error)")
                
            }
        }
    }
}

extension MessagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageTableViewCell.getHeight()
    }
}

extension MessagesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.setMessage(message: message)
        return cell
    }
}
