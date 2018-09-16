//
//  GetCacheImage.swift
//  vk-app
//
//  Created by Andrey Yusupov on 16/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class GetCacheImage: Operation {

    static let avatarFriendsCacheLifeTime: TimeInterval = 86400
    
    var outputImage: UIImage?
    
    private let url: String
    private let cacheLifeTime: TimeInterval
    
    private static let pathName: String = {
        
        let pathName = "avatarImages"
        
        guard let cashesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            else { return pathName }
        let url = cashesDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private lazy var filePath: String? = {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            else { return nil }
        let hasheName = String(describing: url.hashValue)
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + "/" + hasheName).path
    }()
    
    
    
    init(cacheLifeTime: TimeInterval, url: String) {
        
        self.cacheLifeTime = cacheLifeTime
        self.url = url
    }
    
    override func main() {
        
        guard filePath != nil && !isCancelled
            else { return }
        if getImageFromChache() { return }
        guard !isCancelled
            else { return }
        if !downloadImage() { return }
        guard !isCancelled
            else { return }
        saveImageToChache()
    }
    
    private func getImageFromChache() -> Bool {
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else {return false}
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName)
            else { return false }
        self.outputImage = image
        return true
    }
    
    private func downloadImage() -> Bool {
        guard let url = URL(string: url),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
            else { return false }
        self.outputImage = image
        return true
    }
    
    private func saveImageToChache() {
        guard let fileName = filePath,
            let image = outputImage
            else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
