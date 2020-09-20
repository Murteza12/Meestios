//
//  Topic.swift
//  meestApp
//
//  Created by Yash on 8/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - Topics
class Topics {
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

