//
//  DataWorker.swift
//  vk-app
//
//  Created by Andrey Yusupov on 12/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import Foundation
import RealmSwift

class DataWorker {
    
    //MARK: - Save data
    static func saveUserData(_ users: [User]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(users, update: true)
            }
        }
        catch {
            print(error)
            assertionFailure()
        }
    }
    
    //MARK: - Load data
    static func loadUserData() -> Results<User>? {
        do {
            let realm = try Realm()
            return realm.objects(User.self)
        }
        catch  {
            print(error)
            assertionFailure()
            return nil
        }
    }
    
    static func loadUserData(userId: Int) -> User? {
        do {
            let realm = try Realm()
            let user = realm.objects(User.self).filter("userId == %@", userId)
            return Array(user).first
        }
        catch {
            print(error)
            assertionFailure()
            return nil
        }
    }
    
    //MARK: - Delete data
    static func deleteUserFromData(userId: Int) {
        if let deleteUser = DataWorker.loadUserData(userId: userId) {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(deleteUser)
                }
            }
            catch {
                print(error)
                assertionFailure()
            }
        }
    }
}
