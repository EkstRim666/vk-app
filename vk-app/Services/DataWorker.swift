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
            return realm.objects(User.self).filter("whose == %@", Service.getUserId())
        }
        catch  {
            print(error)
            assertionFailure()
            return nil
        }
    }
}
