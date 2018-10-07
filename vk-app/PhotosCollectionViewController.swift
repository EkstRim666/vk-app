//
//  PhotosCollectionViewController.swift
//  vk-app
//
//  Created by Andrey Yusupov on 09/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Photo"

class PhotosCollectionViewController: UICollectionViewController {
    
    private var ownerId: Int = 0
    private var photos: [Photo] = []
    private var tokenPhotos: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.getPhotos(userId: ownerId)
        pairCollectionPhotoAndData()
    }
    
    func setPhotosOwnerId(ownerId: Int) {
        self.ownerId = ownerId
    }
    
    private func pairCollectionPhotoAndData() {
        guard let photos = DataWorker.loadPhotoData(ownerId: ownerId)
            else { return }
        self.photos = Array(photos)
        tokenPhotos = photos.observe {[weak self] (changes) in
            guard let `self` = self
                else { return }
            switch changes {
            case .initial:
                self.collectionView.reloadData()
                
            case let .update(results, _, _, _):
                self.photos = Array(results)
                self.collectionView.reloadData()
                
            case .error(let error):
                assertionFailure("\(error)")
                
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photos = photos[indexPath.row]
        return cell
    }
}
