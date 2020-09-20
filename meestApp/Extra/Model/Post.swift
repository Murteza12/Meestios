//
//  Post.swift
//  meestApp
//
//  Created by Yash on 8/15/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - Post
class Post {
    var id: String
    var posts: [PostElement]
    var caption: String
    var hashTags: [Any?]
    var location: Location
    var topicID, userID: String
    var postLikes, postComments: [PostCommentElement]
    var topic: Topic
    var user: PostUser
    var createdAt:String
    var liked, disliked,commentCounts:Int
    

    init(id: String, posts: [PostElement], caption: String, hashTags: [Any?], location: Location, topicID: String, userID: String, postLikes: [PostCommentElement], postComments: [PostCommentElement], topic: Topic, user: PostUser,createdAt:String,liked:Int,disliked:Int,commentCounts:Int) {
        self.id = id
        self.posts = posts
        self.caption = caption
        self.hashTags = hashTags
        self.location = location
        self.topicID = topicID
        self.userID = userID
        self.postLikes = postLikes
        self.postComments = postComments
        self.topic = topic
        self.user = user
        self.createdAt = createdAt
        self.liked = liked
        self.disliked = disliked
        self.commentCounts = commentCounts
    }
}

// MARK: - Location
class Location {
    var type: String
    var coordinates: [Double]

    init(type: String, coordinates: [Double]) {
        self.type = type
        self.coordinates = coordinates
    }
}

// MARK: - PostCommentElement
class PostCommentElement {
    var id: String
    var comment: String?
    var subCommentID: String?
    var postID, userID: String
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String
    var user: PostCommentUser
    var subcomment:SubComment

    init(id: String, comment: String?, subCommentID: String?, postID: String, userID: String, status: Bool, deletedAt: String, createdAt: String, updatedAt: String, user: PostCommentUser,subcomment:SubComment) {
        self.id = id
        self.comment = comment
        self.subCommentID = subCommentID
        self.postID = postID
        self.userID = userID
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.subcomment = subcomment
    }
}


// MARK: - PostCommentUser
class PostCommentUser {
    var id, username: String
    var displayPicture: String?

    init(id: String, username: String, displayPicture: String?) {
        self.id = id
        self.username = username
        self.displayPicture = displayPicture
    }
}

// MARK: - SubComment
class SubComment {
    var id, comment: String
    var subCommentID: String
    var postID, userID: String
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String
    var user: PostCommentUser

    init(id: String, comment: String, subCommentID: String, postID: String, userID: String, status: Bool, deletedAt: String, createdAt: String, updatedAt: String, user: PostCommentUser) {
        self.id = id
        self.comment = comment
        self.subCommentID = subCommentID
        self.postID = postID
        self.userID = userID
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
    }
}

// MARK: - PostElement
class PostElement {
    var post: String
    var image: Int

    init(post: String, image: Int) {
        self.post = post
        self.image = image
    }
}

// MARK: - Topic
class Topic {
    var id, topic: String
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String

    init(id: String, topic: String, status: Bool, deletedAt: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.topic = topic
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - PostUser
class PostUser {
    var id, firstName: String
    var dob: String
    var lastName, email, username: String
    var displayPicture: String
    var mobile: Int
    var gender: String
    var gToken, fcmToken, fbToken: String
    var likes: Int
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String

    init(id: String, firstName: String, dob: String, lastName: String, email: String, username: String, displayPicture: String, mobile: Int, gender: String, gToken: String, fcmToken: String, fbToken: String, likes: Int, status: Bool, deletedAt: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.firstName = firstName
        self.dob = dob
        self.lastName = lastName
        self.email = email
        self.username = username
        self.displayPicture = displayPicture
        self.mobile = mobile
        self.gender = gender
        self.gToken = gToken
        self.fcmToken = fcmToken
        self.fbToken = fbToken
        self.likes = likes
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
