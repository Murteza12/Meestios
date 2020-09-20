//
//  OthereUser.swift
//  meestApp
//
//  Created by Yash on 9/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - OtherUser
class OtherUser {
    var user: OtherUserr

    init(user: OtherUserr) {
        self.user = user
    }
}

// MARK: - User
class OtherUserr {
    var dob: String
    var displayPicture: String
    var isOnline: Bool
    var lastLoggedIn, ip, ios, about: String
    var id, firstName, lastName, email: String
    var username: String
    var mobile: Int
    var gender: String
    var status: Bool
    var createdAt, accountType,friendStatus: String
    var likes, totalFollowers, totalFollowings, totalPosts: Int
    var posts: [Post]
    var follows: [Any?]

    init(dob: String, displayPicture: String, isOnline: Bool, lastLoggedIn: String, ip: String, ios: String, about: String, id: String, firstName: String, lastName: String, email: String, username: String, mobile: Int, gender: String, status: Bool, createdAt: String, accountType: String, likes: Int, totalFollowers: Int, totalFollowings: Int, totalPosts: Int, posts: [Post], follows: [Any?],friendStatus:String) {
        self.dob = dob
        self.displayPicture = displayPicture
        self.isOnline = isOnline
        self.lastLoggedIn = lastLoggedIn
        self.ip = ip
        self.ios = ios
        self.about = about
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.mobile = mobile
        self.gender = gender
        self.status = status
        self.createdAt = createdAt
        self.accountType = accountType
        self.likes = likes
        self.totalFollowers = totalFollowers
        self.totalFollowings = totalFollowings
        self.totalPosts = totalPosts
        self.posts = posts
        self.follows = follows
        self.friendStatus = friendStatus
    }
}

// MARK: - UserPost
class UserPost {
    var createdAt, id: String
    var posts: [PostPost]
    var caption: String
    var hashTags: [Any?]
    var location: OtherLocation
    var topicID, userID: String
    var status: Bool
    var deletedAt, fontColor, backImg, viewPost: NSNull
    var allowComment: NSNull
    var postType: String
    var locationFrom, locationTo: NSNull
    var updatedAt: String
    var postComments, postLikes: [Any?]

    init(createdAt: String, id: String, posts: [PostPost], caption: String, hashTags: [Any?], location: OtherLocation, topicID: String, userID: String, status: Bool, deletedAt: NSNull, fontColor: NSNull, backImg: NSNull, viewPost: NSNull, allowComment: NSNull, postType: String, locationFrom: NSNull, locationTo: NSNull, updatedAt: String, postComments: [Any?], postLikes: [Any?]) {
        self.createdAt = createdAt
        self.id = id
        self.posts = posts
        self.caption = caption
        self.hashTags = hashTags
        self.location = location
        self.topicID = topicID
        self.userID = userID
        self.status = status
        self.deletedAt = deletedAt
        self.fontColor = fontColor
        self.backImg = backImg
        self.viewPost = viewPost
        self.allowComment = allowComment
        self.postType = postType
        self.locationFrom = locationFrom
        self.locationTo = locationTo
        self.updatedAt = updatedAt
        self.postComments = postComments
        self.postLikes = postLikes
    }
}

// MARK: - Location
class OtherLocation {
    var type: String
    var coordinates: [Double]

    init(type: String, coordinates: [Double]) {
        self.type = type
        self.coordinates = coordinates
    }
}

// MARK: - PostPost
class PostPost {
    var post: String
    var image: Int

    init(post: String, image: Int) {
        self.post = post
        self.image = image
    }
}
