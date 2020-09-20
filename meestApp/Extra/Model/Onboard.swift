//
//  Onboard.swift
//  meestApp
//
//  Created by Yash on 8/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - Onboard
class Onboard {
    var id: String
    var url: String
    var text, userID: String
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String

    init(id: String, url: String, text: String, userID: String, status: Bool, deletedAt: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.url = url
        self.text = text
        self.userID = userID
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
