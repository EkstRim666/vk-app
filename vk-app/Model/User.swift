//
//  User.swift
//  vk-app
//
//  Created by Andrey Yusupov on 03/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation

struct ResponseUsersFromApi: Codable {
    var response: ResponseUsers
}

struct ResponseUsers: Codable {
    var count: Int
    var items: [User]
}

class User: Codable {
    var userId: Int
    var firstName: String
    var lastName: String
    var avatarImage: URL
    var online: Int
    
    enum UserCodingKeys: String, CodingKey {
        case userId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarImage = "photo_100"
        case online
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.avatarImage = try container.decode(URL.self, forKey: .avatarImage)
        self.online = try container.decode(Int.self, forKey: .online)
    }
}
