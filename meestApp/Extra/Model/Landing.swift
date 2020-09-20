//
//  Landing.swift
//  meestApp
//
//  Created by Yash on 8/14/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - Landing
class Landing {
    var id: String
    var url: String
    var text, title: String
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String

    init(id: String, url: String, text: String, title: String, status: Bool, deletedAt: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.url = url
        self.text = text
        self.title = title
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
