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
    
    //MARK: - Request to API VK
    static func getNews() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/newsfeed.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "access_token", value: Service.token),
            URLQueryItem(name: "v", value: Service.versionAPI),
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let responseNewsFromApi = try decoder.decode(ResponseNewsFromApi.self, from: data)
            }
            catch let error {
                print(error)
            }
        }
        
        task.resume()
    }
}
