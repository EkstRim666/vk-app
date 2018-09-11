//
//  News.swift
//  vk-app
//
//  Created by Andrey Yusupov on 10/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation

struct ResponseNewsFromApi: Codable {
    var response: ResponseNews
}

struct ResponseNews: Codable {
    var items: [News]
}

class News: Codable {
    var sourcedId: Int
    var text: String
    var countOfComment: Int
    var countOfLike: Int
    var countOfRepost: Int
    var countOfView: Int
    
    enum NewsCodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case text
        case comments
        case likes
        case reposts
        case views
    }
    
    enum NestedContainerCodingKeys: String, CodingKey {
        case count
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NewsCodingKeys.self)
        self.sourcedId = try container.decode(Int.self, forKey: .sourceId)
        self.text = try container.decode(String.self, forKey: .text)
        
        let commentsContainer = try container.nestedContainer(keyedBy: NestedContainerCodingKeys.self, forKey: .comments)
        self.countOfComment = try commentsContainer.decode(Int.self, forKey: .count)
        
        let likesContainer = try container.nestedContainer(keyedBy: NestedContainerCodingKeys.self, forKey: .likes)
        self.countOfLike = try likesContainer.decode(Int.self, forKey: .count)
        
        let repostsContainer = try container.nestedContainer(keyedBy: NestedContainerCodingKeys.self, forKey: .reposts)
        self.countOfRepost = try repostsContainer.decode(Int.self, forKey: .count)
        
        let viewsContainer = try container.nestedContainer(keyedBy: NestedContainerCodingKeys.self, forKey: .views)
        self.countOfView = try viewsContainer.decode(Int.self, forKey: .count)
    }
}
