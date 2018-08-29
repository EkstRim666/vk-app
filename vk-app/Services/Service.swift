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
    private static var userId: String = ""
    
    //MARK: - Token
    static func setToken(token: String) {
        Service.token = token
    }
    
    static func setUserId(userId: String) {
        Service.userId = userId
    }
    
    static func getUserId() -> String {
        return Service.userId
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
    
    //MARK: - Request to API VK
    static func getGroups(userId: String) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: Service.token),
            URLQueryItem(name: "v", value: Service.versionAPI),
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            
            print(json as Any)
        }
        
        task.resume()
    }
}
