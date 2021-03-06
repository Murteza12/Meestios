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
    
    var attachment, read: Int
    var attachmentType: String
    var fileURL,videothumbnail: String
    var createdAt, deletedAt, id, msg: String
    var status: Int
    var toUserID, updatedAt, userID, category: String
    var sent:Bool
    var senderData:[String:Any]

    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent:Bool,senderData:[String:Any], fileURL: String, attachmentType: String,videothumbnail: String, read: Int, category: String) {
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
        self.attachmentType = attachmentType
        self.fileURL = fileURL
        self.videothumbnail = videothumbnail
        self.read = read
        self.category = category
    }
    
    init(custom: Any?, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String, read: Int, category: String) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent: sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType,videothumbnail:videothumbnail,read: read, category: category)
    }

    init(text: String, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String,read: Int, category: String) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID, sent: sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType, videothumbnail: videothumbnail,read: read, category: category)
    }

    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String,read: Int, category: String) {
    self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent:sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType, videothumbnail:videothumbnail,read: read, category: category)
    }

    init(image: UIImage, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String,read: Int, category: String) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent: sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType, videothumbnail:videothumbnail,read: read, category: category)
    }

    init(thumbnail: UIImage, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail: String,read: Int, category: String) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent:sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType, videothumbnail:videothumbnail,read: read, category: category)
    }

    init(location: CLLocation, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String,read: Int, category: String) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: toUserID,sent: sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType, videothumbnail:videothumbnail,read: read, category: category)
    }

    init(emoji: String, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String,read: Int, category: String) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent: sent,senderData:senderData, fileURL:fileURL,attachmentType:attachmentType, videothumbnail:videothumbnail,read: read, category: category)
    }

    init(audioURL: URL, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String,read: Int, category: String) {
        let audioItem = MockAudiotem(url: audioURL)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID, sent:sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType, videothumbnail:videothumbnail,read: read, category: category)
    }

    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date,attachment: Int, createdAt: String, deletedAt: String, id: String, msg: String, status: Int, toUserID: String, updatedAt: String, userID: String,sent: Bool,senderData:[String:Any], fileURL: String, attachmentType: String, videothumbnail:String,read: Int, category: String) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date,attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: msg, status: status, toUserID: toUserID, updatedAt: updatedAt, userID: userID,sent:sent,senderData:senderData,fileURL:fileURL,attachmentType:attachmentType, videothumbnail:videothumbnail,read: read, category: category)
    }
}



struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
