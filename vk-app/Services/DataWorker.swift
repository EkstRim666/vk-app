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
            assertionFailure("\(error)")
        }
    }
    
    static func savePhotoData(_ photos: [Photo]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(photos, update: true)
            }
        }
        catch {
            assertionFailure("\(error)")
        }
    }
    
    static func saveGroupData(_ groups:[Group], withOwnerId ownerId: Int) {
        groups.forEach {
            $0.ownerId = ownerId
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(groups, update: true)
            }
        }
        catch {
            assertionFailure("\(error)")
        }
    }
    
    //MARK: - Load data
    static func loadUserData() -> Results<User>? {
        do {
            let realm = try Realm()
            return realm.objects(User.self)
        }
        catch  {
            assertionFailure("\(error)")
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
            assertionFailure("\(error)")
            return nil
        }
    }
    
    static func loadPhotoData(ownerId: Int) -> Results<Photo>? {
        do {
            let realm = try Realm()
            return realm.objects(Photo.self).filter("ownerId == %@", ownerId)
        }
        catch  {
            assertionFailure("\(error)")
            return nil
        }
    }
    
    static func loadGroupData(ownerId: Int) -> Results<Group>? {
        do {
            let realm = try Realm()
            return realm.objects(Group.self).filter("ownerId == %@", ownerId)
        }
        catch  {
            assertionFailure("\(error)")
            return nil
        }
    }
    
    static func loadGroupData(groupId: Int) -> Group? {
        do {
            let realm = try Realm()
            let group =  realm.objects(Group.self).filter("groupId == %@", groupId)
            return Array(group).first
        }
        catch  {
            assertionFailure("\(error)")
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
                assertionFailure("\(error)")
            }
        }
    }
}
