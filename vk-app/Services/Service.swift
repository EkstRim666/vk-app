//
//  Service.swift
//  vk-app
//
//  Created by Andrey Yusupov on 26/08/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation

class Service {
    
    private static let versionAPI: String = "5.80"
    private static let client_id: String = "6612791"
    
    private static var token: String = ""
    
    //MARK: - Token
    static func setToken(token: String) {
        Service.token = token
    }
    
    //MARK: - Authorisation VK
    static func authorisation() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Service.client_id),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.vom/blank.html"),
            URLQueryItem(name: "scope", value: "friends, photos, messages, wall, groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: Service.versionAPI),
        ]
        
        return URLRequest(url: urlComponents.url!)
    }
}
