//
//  ChatSetting.swift
//  meestApp
//
//  Created by Rahul Kashyap on 01/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation


class ChatSetting {
    var userId: String?
    var chatHeadId: String?
    var settingType: String?
    var id: String?
    var markPriority: Bool?
    var isNotificationMute: Bool?
    var isReported: Bool?
    var status: Int?

    init(userId: String, chatHeadId: String, settingType: String, id: String, markPriority: Bool, isNotificationMute: Bool, isReported: Bool?, status: Int?) {
        self.userId = userId
        self.chatHeadId = chatHeadId
        self.settingType = settingType
        self.id = id
        self.markPriority = markPriority
        self.isNotificationMute = isNotificationMute
        self.isReported = isReported
        self.status = status
    }
}
