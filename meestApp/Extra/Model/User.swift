//
//  User.swift
//  meestApp
//
//  Created by Yash on 8/12/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation


// MARK: - User
class User {
    var id: String
    var likes: Int
    var email, firstName, lastName: String
    var mobile: Int
    var dob, about: String
    var status: Bool
    var username, gender,dp: String

    init(id: String, likes: Int, email: String, firstName: String, lastName: String, mobile: Int, dob: String, status: Bool, username: String, gender: String,dp:String,about:String) {
        self.id = id
        self.likes = likes
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.dob = dob
        self.status = status
        self.username = username
        self.gender = gender
        self.dp = dp
        self.about = about
    }
    
}

// MARK: - User
class CurrentUser {
    var id: String
    var likes: Int
    var email, firstName, lastName: String
    var mobile,totalFollowers,totalFollowings,totalPosts: Int
    var dob, about: String
    var status: Bool
    var username, gender,dp: String

    init(id: String, likes: Int, email: String, firstName: String, lastName: String, mobile: Int, dob: String, status: Bool, username: String, gender: String,dp:String,about:String,totalFollowers:Int,totalFollowings:Int,totalPosts:Int) {
        self.id = id
        self.likes = likes
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.dob = dob
        self.status = status
        self.username = username
        self.gender = gender
        self.dp = dp
        self.about = about
        
        self.totalPosts = totalPosts
        self.totalFollowers = totalFollowers
        self.totalFollowings = totalFollowings
    }
    
}

// MARK: - User
class ChatUser {
    var id: String
    var likes: Int
    var email, firstName, lastName: String
    var mobile: Int
    var dob, about: String
    var status,isOnline: Bool
    var username, gender,dp: String

    init(id: String, likes: Int, email: String, firstName: String, lastName: String, mobile: Int, dob: String, status: Bool, username: String, gender: String,dp:String,about:String,isOnline:Bool) {
        self.id = id
        self.likes = likes
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.dob = dob
        self.status = status
        self.username = username
        self.gender = gender
        self.dp = dp
        self.about = about
        self.isOnline = isOnline
    }
    
}
