//
//  Message.swift
//  meestApp
//
//  Created by Yash on 8/21/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit
import AVFoundation

private struct CoordinateItem: LocationItem {

    var location: CLLocation
    var size: CGSize

    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }

}

private struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

}

private struct MockAudiotem: AudioItem {

    var url: URL
    var size: CGSize
    var duration: Float

    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        // compute duration
        let audioAsset = AVURLAsset(url: url)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }

}

struct MockContactItem: ContactItem {
    
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
    
    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
    
}

internal struct MockMessage: MessageType {

    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind

    var user: MockUser
    
    var attachment: Int
    var createdAt, deletedAt, id, msg: String
    var status: Int
    var toUserID, updatedAt, userID: String
    var sent:Bool
    var senderData:[String:Any]

    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent:Bool,senderData:[String:Any]) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
        self.attachment = attachment
        self.createdAt = createdAt
        self.deletedAt = deletedAt
        self.id = id
        self.msg = msg
        self.status = status
        self.toUserID = toUserID
        self.updatedAt = updatedAt
        self.userID = userID
        self.sent = sent
        self.senderData=senderData
    }
    
    init(custom: Any?, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent: sent,senderData:senderData)
    }

    init(text: String, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID, sent: sent,senderData:senderData)
    }

    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
    self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent:sent,senderData:senderData)
    }

    init(image: UIImage, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent: sent,senderData:senderData)
    }

    init(thumbnail: UIImage, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent:sent,senderData:senderData)
    }

    init(location: CLLocation, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: toUserID,sent: sent,senderData:senderData)
    }

    init(emoji: String, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent: sent,senderData:senderData)
    }

    init(audioURL: URL, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        let audioItem = MockAudiotem(url: audioURL)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID, sent:sent,senderData:senderData)
    }

    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any]) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent:sent,senderData:senderData)
    }
}



struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
