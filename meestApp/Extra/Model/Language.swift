//
//  Language.swift
//  meestApp
//
//  Created by Yash on 8/25/20.
//  Copyright © 2020 Yash. All rights reserved.
//


import Foundation

// MARK: - Language
class Language {
    var languageNameNative, id, languageNameEnglish: String
    var image: String
    var status: Bool
    var deletedAt: String
    var createdAt, updatedAt: String

    init(languageNameNative: String, id: String, languageNameEnglish: String, image: String, status: Bool, deletedAt: String, createdAt: String, updatedAt: String) {
        self.languageNameNative = languageNameNative
        self.id = id
        self.languageNameEnglish = languageNameEnglish
        self.image = image
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
