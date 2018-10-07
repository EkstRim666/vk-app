//
//  PhotosCollectionViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 09/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Photo"

class PhotosCollectionViewController: UICollectionViewController {
    
    private var ownerId: Int = 0
    private var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setPhotosOwnerId(ownerId: Int) {
        self.ownerId = ownerId
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}
