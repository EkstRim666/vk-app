//
//  SetImageToRow.swift
//  vk-app
//
//  Created by Andrey Yusupov on 16/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class SetImageToRow: Operation {

    static let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    private let indexPath: IndexPath
    
    private weak var cell: UITableViewCell?
    private weak var tableView: UITableView?
    
    init(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage
            else { return }
        if let cell = cell as? FriendTableViewCell {
            if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
                cell.avatar.image = image
            } else if tableView.indexPath(for: cell) == nil {
                cell.avatar.image = image
            }
        }
        if let cell = cell as? GroupTableViewCell {
            if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
                cell.avatar.image = image
            } else if tableView.indexPath(for: cell) == nil {
                cell.avatar.image = image
            }
        }
    }
}
