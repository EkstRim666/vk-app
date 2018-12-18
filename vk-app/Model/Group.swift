//
//  Group.swift
//  vk-app
//
//  Created by Andrey Yusupov on 06/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation
import RealmSwift

struct ResponseGroupsFromApi: Codable {
    var response: ResponseGroups
}

struct ResponseGroups: Codable {
    var count: Int
    var items: [Group]
}

class Group: Object, Codable {
    @objc dynamic var groupId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var isMember: Int = -1
    @objc dynamic var avatarImage: String = ""
    @objc dynamic var bigAvatarImage: String = ""
    @objc dynamic var ownerId: Int = 0
    
    enum GroupCodingKeys: String, CodingKey {
        case groupId = "id"
        case name
        case screenName = "screen_name"
        case isMember = "is_member"
        case avatarImage = "photo_100"
        case bigAvatarImage = "photo_200"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: GroupCodingKeys.self)
        self.groupId = try container.decode(Int.self, forKey: .groupId)
        self.name = try container.decode(String.self, forKey: .name)
        self.screenName = try container.decode(String.self, forKey: .screenName)
        self.isMember = try container.decode(Int.self, forKey: .isMember)
        self.avatarImage = try container.decode(String.self, forKey: .avatarImage)
        self.bigAvatarImage = try container.decode(String.self, forKey: .bigAvatarImage)
    }
    
    override static func primaryKey() -> String? {
        return "groupId"
    }
}
