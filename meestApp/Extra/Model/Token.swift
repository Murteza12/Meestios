//
//  Token.swift
//  meestApp
//
//  Created by Yash on 8/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import RealmSwift

class Token:Object {
    
    static let sharedInstance = Token()
    @objc dynamic var token = ""
    @objc dynamic var userid = ""
    @objc dynamic var username = ""
    
    func getToken() -> String {
        let all = try! Realm().objects(Token.self)
        if all.count > 0 {
            return all[0].token
        }
        return ""
    }
    func getUserId() -> String {
        let all = try! Realm().objects(Token.self)
        if all.count > 0 {
            return all[0].userid
        }
        return ""
    }
    func getUsername() -> String {
        let all = try! Realm().objects(Token.self)
        if all.count > 0 {
            return all[0].username
        }
        return ""
    }
}
