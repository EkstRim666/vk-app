//
//  PhotoCollectionViewCell.swift
//  vk-app
//
//  Created by Andrey Yusupov on 09/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var photos: Photo? {
        didSet {
            guard let imageUrl = photos?.imageUrl
                else { return }
            photo.downloadedFrom(link: imageUrl)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photo.image = nil
    }
}
