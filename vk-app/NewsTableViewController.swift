//
//  NewsTableViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 10/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        
        Service.getNews() {[weak self] news in
            self?.news = news
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as! NewsTableViewCell
        let news = self.news[indexPath.row]
        cell.textOfNews.text = news.text
        cell.countOfComment.text = "💬 \(news.countOfComment)"
        cell.countOfLike.text = "♥️ \(news.countOfLike)"
        cell.countOfRepost.text = "📣 \(news.countOfRepost)"
        cell.countOfView.text = "👁‍🗨 \(news.countOfView)"
        if news.sourcedId < 0 {
            guard let group = DataWorker.loadGroupData(groupId: -news.sourcedId)
                else {
                    
                    return cell
                    
            }
            cell.author.text = group.name
            let getCacheImage = GetCacheImage(cacheLifeTime: GetCacheImage.avatarGroupsCacheLifeTime, url: group.avatarImage)
            let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            SetImageToRow.queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
    } else {
            guard let user = DataWorker.loadUserData(userId: news.sourcedId)
                else {return cell}
            cell.author.text = user.name
            let getCacheImage = GetCacheImage(cacheLifeTime: GetCacheImage.avatarFriendsCacheLifeTime, url: user.avatarImage)
            let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            SetImageToRow.queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
        }
        return cell
    }
}
