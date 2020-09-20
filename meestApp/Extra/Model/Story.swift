//
//  Story.swift
//  meestApp
//
//  Created by Yash on 8/19/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - Story
class Story {
    var createdAt, id: String
    var story: String
    var caption: String
    var hashTags: [Any?]
    var topicID, userID: String
    var image: Bool
    var viewCount: Int
    var storyViewers: [Any?]
    var storyUSer: StoryUSer
    

    init(createdAt: String, id: String, story: String, caption: String, hashTags: [Any?], topicID: String, userID: String, image: Bool, viewCount: Int, storyViewers: [Any?], storyUSer: StoryUSer) {
        self.createdAt = createdAt
        self.id = id
        self.story = story
        self.caption = caption
        self.hashTags = hashTags
        self.topicID = topicID
        self.userID = userID
        self.image = image
        self.viewCount = viewCount
        self.storyViewers = storyViewers
        self.storyUSer = storyUSer
    }
}

// MARK: - StoryUSer
class StoryUSer {
    var id, username, firstName, lastName: String
    var email,displayPicture: String

    init(id: String, username: String, firstName: String, lastName: String, email: String,displayPicture:String) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.displayPicture = displayPicture
    }
}
