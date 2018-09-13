//
//  User.swift
//  vk-app
//
//  Created by Andrey Yusupov on 03/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation
import RealmSwift

struct ResponseUsersFromApi: Codable {
    var response: ResponseUsers
}

struct ResponseUsers: Codable {
    var count: Int
    var items: [User]
}

class User: Object, Codable {
    @objc dynamic var userId: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatarImage: URL = URL(string: "https://vk.com/images/deactivated_100.png")!
    @objc dynamic var online: Int = 0
    @objc dynamic var whose: Int = 0
    
    var name: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    
    enum UserCodingKeys: String, CodingKey {
        case userId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarImage = "photo_100"
        case online
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.avatarImage = try container.decode(URL.self, forKey: .avatarImage)
        self.online = try container.decode(Int.self, forKey: .online)
        self.whose = Service.getUserId()
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
