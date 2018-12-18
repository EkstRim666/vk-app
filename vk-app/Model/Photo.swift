//
//  Photo.swift
//  vk-app
//
//  Created by Andrey Yusupov on 09/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation
import RealmSwift

struct ResponsePhotosFromApi: Codable {
    var response: ResponsePhotos
}

struct ResponsePhotos: Codable {
    var count: Int
    var items: [Photo]
}

class Photo: Object, Codable {
    
    @objc dynamic var photoId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageUrl: String = ""
    var sizes: [Size] = []
    
    enum PhotoCodingKeys: String, CodingKey {
        case photoId = "id"
        case name = "text"
        case ownerId = "owner_id"
        case sizes
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: PhotoCodingKeys.self)
        self.photoId = try container.decode(Int.self, forKey: .photoId)
        self.name = try container.decode(String.self, forKey: .name)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.sizes = try container.decode([Size].self, forKey: .sizes)
        self.sizes.forEach {
            if $0.type == "x" {
                self.imageUrl = $0.url
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "photoId"
    }
}

struct Size: Codable {
    var type: String
    var url: String
    var width: Int
    var height: Int
}
