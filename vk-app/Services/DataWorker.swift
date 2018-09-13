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
}
