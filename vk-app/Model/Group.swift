//
//  Group.swift
//  vk-app
//
//  Created by Andrey Yusupov on 06/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation

struct ResponseGroupsFromApi: Codable {
    var response: ResponseGroups
}

struct ResponseGroups: Codable {
    var count: Int
    var items: [Group]
}

class Group: Codable {
    var groupId: Int
    var name: String
    var screenName: String
    var isMember: Int
    var avatarImage: URL
    var bigAvatarImage: URL
    
    enum GroupCodingKeys: String, CodingKey {
        case groupId = "id"
        case name
        case screenName = "screen_name"
        case isMember = "is_member"
        case avatarImage = "photo_100"
        case bigAvatarImage = "photo_200"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GroupCodingKeys.self)
        self.groupId = try container.decode(Int.self, forKey: .groupId)
        self.name = try container.decode(String.self, forKey: .name)
        self.screenName = try container.decode(String.self, forKey: .screenName)
        self.isMember = try container.decode(Int.self, forKey: .isMember)
        self.avatarImage = try container.decode(URL.self, forKey: .avatarImage)
        self.bigAvatarImage = try container.decode(URL.self, forKey: .bigAvatarImage)
    }
}
