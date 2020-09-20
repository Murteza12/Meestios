//
//  SuggestedUser.swift
//  meestApp
//
//  Created by Yash on 9/12/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

// MARK: - OtherUser
class SuggestedUser {
    var id, firstName, lastName: String
    var displayPicture: String
    var email, username: String
    var mobile: Int
    var password, gender: String
    var gTOken, fbToken: String
    var likes, status: Int
    var deletedAt: String
    var createdAt, updatedAt: String
    var otp, otpExpires, fcmToken: String
    var dob: String
    var  lastLoggedIn, ip, ios: String
    var about: String
    var accountType: String
    var deviceVoipToken, adharFront, adharBack, adharNumber: String
    var isAdharVerified: Int
    var lat, lag: String
    var isOnline:Bool

    init(id: String, firstName: String, lastName: String, displayPicture: String, email: String, username: String, mobile: Int, password: String, gender: String, gTOken: String, fbToken: String, likes: Int, status: Int, deletedAt: String, createdAt: String, updatedAt: String, otp: String, otpExpires: String, fcmToken: String, dob: String, isOnline: Bool, lastLoggedIn: String, ip: String, ios: String, about: String, accountType: String, deviceVoipToken: String, adharFront: String, adharBack: String, adharNumber: String, isAdharVerified: Int, lat: String, lag: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.displayPicture = displayPicture
        self.email = email
        self.username = username
        self.mobile = mobile
        self.password = password
        self.gender = gender
        self.gTOken = gTOken
        self.fbToken = fbToken
        self.likes = likes
        self.status = status
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.otp = otp
        self.otpExpires = otpExpires
        self.fcmToken = fcmToken
        self.dob = dob
        self.isOnline = isOnline
        self.lastLoggedIn = lastLoggedIn
        self.ip = ip
        self.ios = ios
        self.about = about
        self.accountType = accountType
        self.deviceVoipToken = deviceVoipToken
        self.adharFront = adharFront
        self.adharBack = adharBack
        self.adharNumber = adharNumber
        self.isAdharVerified = isAdharVerified
        self.lat = lat
        self.lag = lag
    }
}

