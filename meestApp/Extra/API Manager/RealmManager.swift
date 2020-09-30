//
//  RealmManager.swift
//  Axxess
//
//  Created by Rahul Kashyap on 21/07/20.
//  Copyright © 2020 Rahul Kashyap. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
     
    let realm = try! Realm()
    
    func deleteDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    func saveObjects(objs: Object) {
        self.deleteDatabase()
        try! realm.write({
            // If update = true, objects that are already in the Realm will be 
            // updated instead of added a new.
            realm.add(objs)
        })
    }
    
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm.objects(type)
    }
}
