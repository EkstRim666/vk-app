//
//  Photo.swift
//  vk-app
//
//  Created by Andrey Yusupov on 09/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation

struct ResponsePhotosFromApi: Codable {
    var response: ResponsePhotos
}

struct ResponsePhotos: Codable {
    var count: Int
    var items: [Photo]
}

class Photo: Codable {
    
    var photoId: Int
    var name: String
    var ownerId: Int
    var sizes: [Size]
    
    enum PhotoCodingKeys: String, CodingKey {
        case photoId = "id"
        case name = "text"
        case ownerId = "owner_id"
        case sizes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotoCodingKeys.self)
        self.photoId = try container.decode(Int.self, forKey: .photoId)
        self.name = try container.decode(String.self, forKey: .name)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.sizes = try container.decode([Size].self, forKey: .sizes)
    }
}

struct Size: Codable {
    var type: String
    var url: URL
    var width: Int
    var height: Int
}
