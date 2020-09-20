//
//  Comment.swift
//  meestApp
//
//  Created by Yash on 8/19/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - Comment
class Comment {
    var id, comment: String
    var subCommentID: String
    var postID, userID: String
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String
    var user: UserComment
    var commentLikes: [Any?]
    var subCommentData: String

    init(id: String, comment: String, subCommentID: String, postID: String, userID: String, status: Bool, deletedAt: String, createdAt: String, updatedAt: String, user: UserComment, commentLikes: [Any?], subCommentData: String) {
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
        self.commentLikes = commentLikes
        self.subCommentData = subCommentData
    }
}

// MARK: - User
class UserComment {
    var id, username: String
    var displayPicture: String

    init(id: String, username: String, displayPicture: String) {
        self.id = id
        self.username = username
        self.displayPicture = displayPicture
    }
}

