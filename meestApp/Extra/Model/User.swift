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
    var status, mediaAutoDownload: Bool
    var username, gender,dp: String

    init(id: String, likes: Int, email: String, firstName: String, lastName: String, mobile: Int, dob: String, status: Bool, username: String, gender: String,dp:String,about:String,totalFollowers:Int,totalFollowings:Int,totalPosts:Int, mediaAutoDownload:Bool) {
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
        self.mediaAutoDownload = mediaAutoDownload
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

// MARK: - ChatHeads
class ChatHeads{
    var id: String
    var likes: Int
    var email, firstName, lastName: String
    var mobile: Int
    var dob, about: String
    var status,isOnline: Bool
    var username, gender,dp,chatHeadId: String
    var chat: [[String:Any]]

    init(id: String, likes: Int, email: String, firstName: String, lastName: String, mobile: Int, dob: String, status: Bool, username: String, gender: String,dp:String,about:String,isOnline:Bool,chat:[[String:Any]], chatHeadId: String) {
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
        self.chat = chat
        self.chatHeadId = chatHeadId
    }
    
}

class groupHeads {
    var chat : [[String:Any]]
    var groupAdminData : [String:Any]
    var groupIcon : String
    var groupName : String
    var id : String
    var isGroup : Bool
    
    init(id: String, groupIcon: String, isGroup: Bool, groupname: String, groupAdminData: [String:Any], chat:[[String:Any]]) {
        self.id = id
        self.groupIcon = groupIcon
        self.isGroup = isGroup
        self.groupName = groupname
        self.chat = chat
        self.groupAdminData = groupAdminData
    }
}
