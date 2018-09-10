//
//  NewsTableViewCell.swift
//  vk-app
//
//  Created by Andrey Yusupov on 10/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var countOfComint: UILabel!
    @IBOutlet weak var countOfLook: UILabel!
    @IBOutlet weak var countOfLike: UILabel!
    @IBOutlet weak var countOfRepost: UILabel!
    @IBOutlet weak var textOfNews: UILabel!
    
    override func prepareForReuse() {
        avatar.image = nil
        author.text = nil
        countOfComint.text = nil
        countOfLike.text = nil
        countOfRepost.text = nil
        countOfLook.text = nil
        textOfNews.text = nil
    }
}
