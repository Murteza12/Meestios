//
//  Constant.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

struct BASEURL {
    static let baseurl = "https://apiserver.dbmdemo.com"
    static let socketURL = "https://socket.dbmdemo.com"
}

struct APIS {
    static let verifyEmail = BASEURL.baseurl + "/pub/verifyEmail"
    static let otpVerify = BASEURL.baseurl + "/pub/otpVerification"
    static let mobileVerify = BASEURL.baseurl + "/pub/mobileVerify"
    static let verifyMobile = BASEURL.baseurl + "/pub/verifyMobile"
    static let verifyOTP = BASEURL.baseurl + "/pub/verifyOTP"
    static let forgotPassword = BASEURL.baseurl + "/pub/forgotPassword"
    static let verifyUsername = BASEURL.baseurl + "/pub/verifyUsername"
    static let register = BASEURL.baseurl + "/pub/register"
    static let login = BASEURL.baseurl + "/pub/login"
    static let changePassword = BASEURL.baseurl + "/user/changePassword"
    static let getAllLang = BASEURL.baseurl + "/pub/languages"
    static let topicGetAll = BASEURL.baseurl + "/topics/getAll"
    static let onboard = BASEURL.baseurl + "/pub/onBoard"
    static let update = BASEURL.baseurl + "/user/update"
    static let profilePic = BASEURL.baseurl + "/media/insert"
    static let submitTopic = BASEURL.baseurl + "/userTopics/insert"
    static let currentuser = BASEURL.baseurl + "/user/me"
    static let landing = BASEURL.baseurl + "/pub/afterSIgnup"
    static let post = BASEURL.baseurl + "/post/getAll"
    static let postLike = BASEURL.baseurl + "/post/insertLike"
    static let postDislike = BASEURL.baseurl + "/post/insertDislike"
    static let postComment = BASEURL.baseurl + "/post/insertComment"
    static let chat = BASEURL.baseurl + "/chat/getChat"
    static let story = BASEURL.baseurl + "/stories/getAll"
    static let insertStory = BASEURL.baseurl + "/stories/insert"
    static let insertView = BASEURL.baseurl + "/stories/insertView"
    static let getComment = BASEURL.baseurl + "/post/getComments"
    static let deleteComment = BASEURL.baseurl + "/post/removeComment"
    static let commentLike = BASEURL.baseurl + "/post/commentLike"
    static let createRoom = BASEURL.baseurl + "/chat/createRoom"
    static let recevieCall = BASEURL.baseurl + "/chat/receiveCall"
    static let declineCall = BASEURL.baseurl + "/chat/declineCall"
    static let missedCall = BASEURL.baseurl + "/chat/missedCall"
    static let endCell = BASEURL.baseurl + "/chat/endCall"
    static let otherUser = BASEURL.baseurl + "/admin/userProfile"
    static let suggestionUser = BASEURL.baseurl + "/follows/suggestUser"
    static let getFollowData = BASEURL.baseurl + "/follows/followsData"
    static let postInsert = BASEURL.baseurl + "/post/insert"
    static let getGroupsFrom =  BASEURL.baseurl + "/chat/getGroupsFrom"
    static let deleteChat =  BASEURL.baseurl + "/chat/deleteChat"
    static let softDelete =  BASEURL.baseurl + "/chat/softDelete/group"
    static let hardDelete =  BASEURL.baseurl + "/chat/hardDelete/group"
    static let getGroupChatHeads = BASEURL.baseurl + "/chat/chatHeads"
    static let followGetFriends = BASEURL.baseurl + "/follows/get/friends"
    static let clearChat = BASEURL.baseurl + ""
    static let blockContact = BASEURL.baseurl + ""
    static let deleteChatHeads = BASEURL.baseurl + ""
    static let reportUser = BASEURL.baseurl + ""
    static let mediaLinksDocs = BASEURL.baseurl + ""
    static let exportChat = BASEURL.baseurl + ""
    static let muteNotification = BASEURL.baseurl + ""
    
}
struct Themes {
    static let animationName = "lf30_editor_9mg9X1"
    static let like = "14107-like-thumb"
    static let save = "22515-bookmark"
}

struct APPFont {
    
    static let regular = "NunitoSans-Regular"
    static let bold = "NunitoSans-Bold"
    static let extralight = "NunitoSans-ExtraLight"
    static let semibold = "NunitoSans-SemiBold"
}

var isSender: Bool = false
