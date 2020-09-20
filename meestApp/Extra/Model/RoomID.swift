//
//  RoomID.swift
//  meestApp
//
//  Created by Yash on 9/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - RoomID
class RoomID {
    var id: String
    var status: Bool
    var userID: String
    var group, video: Bool
    var updatedAt, createdAt: String

    init(id: String, status: Bool, userID: String, group: Bool, video: Bool, updatedAt: String, createdAt: String) {
        self.id = id
        self.status = status
        self.userID = userID
        self.group = group
        self.video = video
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
