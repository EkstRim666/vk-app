//
//  Message.swift
//  vk-app
//
//  Created by Andrey Yusupov on 08/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation

struct ResponseMessagesFromApi: Codable {
    var response: ResponseMessages
}

struct ResponseMessages: Codable {
    var count: Int
    var items: [Message]
}

class Message: Codable {
    var text: String = ""
    var fromId: Int
    var messageId: Int
//    var attachments: [Attachments]
    
    enum MessageCodingKeys: String, CodingKey {
        case fromId = "from_id"
        case text
        case messageId = "id"
//        case attachments
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MessageCodingKeys.self)
        self.fromId = try container.decode(Int.self, forKey: .fromId)
        self.messageId = try container.decode(Int.self, forKey: .messageId)
        self.text = try container.decode(String.self, forKey: .text)
//        self.attachments = try container.decode(Attachments.self, forKey: .attachments)
    }
}
