//
//  Message.swift
//  vk-app
//
//  Created by Andrey Yusupov on 08/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation
import RealmSwift

struct ResponseMessagesFromApi: Codable {
    var response: ResponseMessages
}

struct ResponseMessages: Codable {
    var count: Int
    var items: [Message]
}

class Message: Object, Codable {
    @objc dynamic var text: String = ""
    @objc dynamic var fromId: Int = 0
    @objc dynamic var messageId: Int = 0
    @objc dynamic var ownerId: Int = 0
    
    enum MessageCodingKeys: String, CodingKey {
        case fromId = "from_id"
        case text
        case messageId = "id"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: MessageCodingKeys.self)
        self.fromId = try container.decode(Int.self, forKey: .fromId)
        self.messageId = try container.decode(Int.self, forKey: .messageId)
        self.text = try container.decode(String.self, forKey: .text)
    }
    
    override static func primaryKey() -> String? {
        return "messageId"
    }
}
