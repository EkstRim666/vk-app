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
    private static var userId: Int = 0
    
    //MARK: - Token
    static func setToken(token: String) {
        Service.token = token
    }
    
    static func setUserId(userId: String) {
        guard let userId = Int(userId) else { return }
        Service.userId = userId
    }
    
    static func getUserId() -> Int {
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
    static func getFriends(userId: Int) {
        DispatchQueue.global().async {
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            var urlConstructor = URLComponents()
            
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/friends.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(userId)),
                URLQueryItem(name: "order", value: "hints"),
                URLQueryItem(name: "fields", value: "first_name, last_name, photo_50, photo_100, photo_200_orig"),
                URLQueryItem(name: "access_token", value: Service.token),
                URLQueryItem(name: "v", value: Service.versionAPI),
            ]
            
            let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let responseUserFromApi = try decoder.decode(ResponseUsersFromApi.self, from: data)
                    DataWorker.saveUserData(responseUserFromApi.response.items)
                }
                catch let error {
                    assertionFailure("\(error)")
                }
            }
            
            task.resume()
        }
    }
    
    static func getMessage(userId: Int) {
        DispatchQueue.global().async {
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            var urlConstructor = URLComponents()
            
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/messages.getHistory"
            urlConstructor.queryItems = [
                URLQueryItem(name: "count", value: "200"),
                URLQueryItem(name: "user_id", value: String(userId)),
                URLQueryItem(name: "access_token", value: Service.token),
                URLQueryItem(name: "v", value: Service.versionAPI),
            ]
            
            let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let responseMessagesFromApi = try decoder.decode(ResponseMessagesFromApi.self, from: data)
                    DataWorker.saveMessageData(responseMessagesFromApi.response.items, withOwnerId: userId)
                }
                catch let error {
                    assertionFailure("\(error)")
                }
            }
            
            task.resume()
        }
    }
    
    static func getPhotos(userId: Int) {
        DispatchQueue.global().async {
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            var urlConstructor = URLComponents()
            
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/photos.getAll"
            urlConstructor.queryItems = [
                URLQueryItem(name: "count", value: "200"),
                URLQueryItem(name: "owner_id", value: String(userId)),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: Service.token),
                URLQueryItem(name: "v", value: Service.versionAPI),
            ]
            
            let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let responsePhotosFromApi = try decoder.decode(ResponsePhotosFromApi.self, from: data)
                    DataWorker.savePhotoData(responsePhotosFromApi.response.items)
                }
                catch let error {
                    assertionFailure("\(error)")
                }
            }
            
            task.resume()
        }
    }
    
    static func getGroups(userId: Int) {
        DispatchQueue.global().async {
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            var urlConstructor = URLComponents()
            
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/groups.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(userId)),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: Service.token),
                URLQueryItem(name: "v", value: Service.versionAPI),
            ]
            
            let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let responseGroupFromApi = try decoder.decode(ResponseGroupsFromApi.self, from: data)
                    DataWorker.saveGroupData(responseGroupFromApi.response.items, withOwnerId: userId)
                }
                catch let error {
                    assertionFailure("\(error)")
                }
            }
            
            task.resume()
        }
    }
    
    static func searchGroupName(_ searchName: String, comletion: @escaping ([Group]) -> Void) {
        DispatchQueue.global().async {
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            var urlConstructor = URLComponents()
            
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/groups.search"
            urlConstructor.queryItems = [
                URLQueryItem(name: "q", value: searchName),
                URLQueryItem(name: "sort", value: "0"),
                URLQueryItem(name: "count", value: "1000"),
                URLQueryItem(name: "access_token", value: Service.token),
                URLQueryItem(name: "v", value: Service.versionAPI),
            ]
            
            let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let responseGroupFromApi = try decoder.decode(ResponseGroupsFromApi.self, from: data)
                    comletion(responseGroupFromApi.response.items)
                }
                catch let error {
                    assertionFailure("\(error)")
                }
            }
            
            task.resume()
        }
    }
    
    static func getNews(comletion: @escaping ([News]) -> Void) {
        DispatchQueue.global().async {
            if DataWorker.loadGroupData(ownerId: Service.getUserId())?.count == 0 {
                Service.getGroups(userId: Service.getUserId())
            }
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
                    comletion(responseNewsFromApi.response.items)
                }
                catch let error {
                    assertionFailure("\(error)")
                }
            }
            
            task.resume()
        }
    }
    
    static func deleteUser(userId: Int) {
        DispatchQueue.global().async {
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            var urlConstructor = URLComponents()
            
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/friends.delete"
            urlConstructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(userId)),
                URLQueryItem(name: "access_token", value: Service.token),
                URLQueryItem(name: "v", value: Service.versionAPI),
            ]
            
            let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    else { return }
                if let responseDeleteFromApi = json as? [String: Any] {
                    if let responseJson = responseDeleteFromApi["response"] as? [String: Any] {
                        if let success = responseJson["success"] as? Int {
                            if success == 1 {
                                DataWorker.deleteUserFromData(userId: userId)
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
