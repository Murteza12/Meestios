//
//  APIManager.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SocketIO

class APIManager {
    
    static let sharedInstance = APIManager()
    let realm = try! Realm()
//    let manager = SocketManager.init(socketURL: URL.init(string: BASEURL.socketURL)!, config: [.compress,.log(true)])
//    var socket:SocketIOClient!
    
    func addToken(token:String,completion:@escaping () -> Void) {
        let realm = try! Realm()
        let t1 = Token()
        t1.token = token
        print(token)
        try! realm.write {
            realm.add(t1)
            
        }
        completion()
    }
    func clearDB(completion:@escaping () -> Void) {
        let realm = try! Realm()
        let all = try! Realm().objects(Token.self)
        
        try! realm.write {
            realm.delete(all)
            
        }
        completion()
    }
    
    func getAllLang(vc:RootBaseVC,completion:@escaping ([Language]) -> Void) {
        APICall.sharedInstance.alamofireCall(url: APIS.getAllLang, method: .get, para: "", header: [:], vc: vc) { (url, responseData, statusCode) in
            var all = [Language]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let rows = innerData["rows"] as! [[String:Any]]
                for i in rows {
                    let languageNameNative = i["languageNameNative"] as? String ?? ""
                    let id = i["id"] as? String ?? ""
                    let languageNameEnglish = i["languageNameEnglish"] as? String ?? ""
                    let image = i["image"] as? String ?? ""
                    let status = i["status"] as? Bool ?? false
                    let temp = Language.init(languageNameNative: languageNameNative, id: id, languageNameEnglish: languageNameEnglish, image: image, status: status, deletedAt: "", createdAt: "", updatedAt: "")
                    
                    all.append(temp)
                }
                completion(all)
                
            }
        }
    }
    
    func verifyEmail(vc:RootBaseVC,email:String,completion:@escaping(String) -> Void) {
        let para = ["mobile":email]
        APICall.sharedInstance.alamofireCall(url: APIS.verifyEmail, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let message = innerData["message"] as? String ?? ""
                completion(message)
            }else if statusCode == 400 {
                
            }
        }
    }
    
    func forgotpassword(vc:RootBaseVC,email:String,completion:@escaping(String) -> Void) {
        let para = ["mobile":email]
        APICall.sharedInstance.alamofireCall(url: APIS.forgotPassword, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let message = innerData["message"] as? String ?? ""
                completion(message)
            }
        }
    }
    
    func verifyMobile(vc:RootBaseVC,mobile:String,completion:@escaping(String) -> Void) {
        let para = ["mobile":mobile]
        APICall.sharedInstance.alamofireCall(url: APIS.mobileVerify, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let message = innerData["message"] as? String ?? ""
                    completion(message)
                }else {
                    let errormsg = data["errorMessage"] as? [String:Any] ?? [:]
                    let msg = errormsg["message"] as? String ?? ""
                    completion(msg)
                }
            }
        }
    }
    func verifyotp(vc:RootBaseVC,mobile:String,otp:String,completion:@escaping(String) -> Void) {
        let para = ["mobile":mobile,"otp":otp]
        APICall.sharedInstance.alamofireCall(url: APIS.otpVerify, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let message = innerData["message"] as? String ?? ""
                    completion(message)
                }else {
                    let errormsg = data["errorMessage"] as? String ?? ""
                    completion(errormsg)
                }
                
            } else if statusCode == 0 {
                let data = responseData.value as! [String:Any]
                let errormsg = data["errorMessage"] as? String ?? ""
                completion(errormsg)
            }
        }
    }
    func verifyMobilesignup(vc:RootBaseVC,mobile:String,completion:@escaping(String) -> Void) {
        let para = ["mobile":mobile]
        APICall.sharedInstance.alamofireCall(url: APIS.verifyMobile, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let message = innerData["message"] as? String ?? ""
                    completion(message)
                } else {
                    let error = data["errorMessage"] as! [String:Any]
                    let message = error["message"] as? String ?? ""
                    completion(message)
                }
                
                
                
                
            }
        }
    }
    func verifyOTPForgotPass(vc:RootBaseVC,mobile:String,otp:String,completion:@escaping(String) -> Void) {
        let para = ["mobile":mobile,"otp":otp]
        APICall.sharedInstance.alamofireCall(url: APIS.verifyOTP, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let message = innerData["message"] as? String ?? ""
                    completion(message)
                }else {
                    if let errormsg = data["errorMessage"] as? [String:Any] {
                        if let message = errormsg["message"] as? String {
                            completion(message)
                        }
                    }
                }
                
            } else if statusCode == 0 {
                let data = responseData.value as! [String:Any]
                let errormsg = data["errorMessage"] as? String ?? ""
                completion(errormsg)
            }

        }
    }
    func login(vc:RootBaseVC,username:String,password:String,completion:@escaping(String) -> Void) {
        let para = ["username": "+91" + username,"password":password]
        APICall.sharedInstance.alamofireCall(url: APIS.login, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                guard let data = responseData.value as? [String : Any] else {
                    return
                }
                //                let data = responseData.value as? [String:Any] ?? [:]
                if let code = data["code"] as? Bool{
                    if code{
                        let innerData = data["data"] as? [String:Any] ?? [:]
                        let token = innerData["token"] as? String ?? ""
                        
                        self.clearDB {
                            self.addToken(token: token) {
                                self.getCurrentUser(vc: RootBaseVC()) { (user) in
                                    completion("success")
                                }
                            }
                        }
                    }else{
                        if let message = data["errorMessage"] as? String {
                            completion(message)
                        }
                    }
                }
                
            } else if statusCode == 400 {
                let data = responseData.value as! [String:Any]
                let message = data["errorMessage"] as? String ?? ""
                completion(message)
            }
        }
    }
    
    func registerUser(vc:RootBaseVC,username:String,mobile:String,email:String,password:String,completion:@escaping (String) -> Void) {
        let para = ["username":username,"mobile":mobile,"email":email,"password":password]
        APICall.sharedInstance.alamofireCall(url: APIS.register, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let token = innerData["token"] as? String ?? ""
                self.clearDB {
                    self.addToken(token: token) {
                        completion("success")
                    }
                }
                
            } else if statusCode == 500 {
                let data = responseData.value as! [String:Any]
                let msg = data["errorMessage"] as? String ?? ""
                vc.showAlert(title: "Message", message: msg)
            }
        }
    }
    
    func getAllTopic(vc:RootBaseVC,completion:@escaping ([Topics]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.topicGetAll, method: .post, para: "", header: header, vc: vc) { (url, responseData, statusCode) in
            var all = [Topics]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let rows = innerData["rows"] as! [[String:Any]]
                for i in rows {
                    let id = i["id"] as? String ?? ""
                    let topic = i["topic"] as? String ?? ""
                    let status = i["status"] as? Bool ?? true
                    all.append(Topics.init(id: id, topic: topic, status: status, deletedAt: "", createdAt: "", updatedAt: ""))
                }
                completion(all)
            }
        }
    }
    
    func geetonboardData(vc:RootBaseVC,completion:@escaping ([Onboard]) -> Void) {
        APICall.sharedInstance.alamofireCall(url: APIS.onboard, method: .post, para: "", header: [:], vc: vc) { (url, responseData, statusCode) in
            var all = [Onboard]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let rows = innerData["rows"] as! [[String:Any]]
                for i in rows {
                    let id = i["id"] as? String ?? ""
                    let url = i["url"] as? String ?? ""
                    let text = i["text"] as? String ?? ""
                    let status = i["status"] as? Bool ?? true
                    
                    all.append(Onboard.init(id: id, url: url, text: text, userID: "", status: status, deletedAt: "", createdAt: "", updatedAt: ""))
                }
                completion(all)
            }
        }
    }
    
    func submitGender(vc:RootBaseVC,gender:String,completion:@escaping (String) -> Void) {
        let para = ["gender":gender]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.update, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                completion("success")
            }
        }
    }
    
    func updateAutodownload(vc:RootBaseVC,mediaAutoDownload:Bool,completion:@escaping (String) -> Void) {
        let para = ["mediaAutoDownload":mediaAutoDownload]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.update, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                completion("success")
            }
        }
    }
    func submitURL(vc:UIViewController,displayPicture:String,completion:@escaping (String) -> Void) {
        let para = ["displayPicture":displayPicture]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.update, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                completion("success")
            }
        }
    }
    func uploadImage(vc:UIViewController,img:UIImage,completion:@escaping(String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        
        let imgData1 = img.jpegData(compressionQuality: 0.5)
        let imageSize = imgData1?.count
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData1!, withName: "image", fileName: "fileName" + ".jpg",mimeType: "image/jpeg")
            
            print(multipartFormData.contentType)
        }, to: APIS.profilePic,method: .post,headers: header).responseJSON { response in
            print(response)
            if response.response?.statusCode == 200 {
                let data = response.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let url = innerData["url"] as? String ?? ""
                UserDefaults.standard.set(url, forKey: "IMG")
                self.submitURL(vc: vc, displayPicture: url) { (str) in
                    if str == "success" {
                        completion("success")
                    }
                }
            } else if response.response?.statusCode == 503 {
                
            } else {
                completion("failure")
            }
        }
    }
    
    func uploadAudio(vc:UIViewController, url:URL, fileName: String,completion:@escaping(String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(url, withName: fileName)
            
            print(multipartFormData.contentType)
        }, to: APIS.profilePic,method: .post,headers: header).responseJSON { response in
            print(response)
            if response.response?.statusCode == 200 {
                let data = response.value as? [String:Any] ?? [:]
                let innerData = data["data"] as? [String:Any] ?? [:]
                let url = innerData["url"] as? String ?? ""
                UserDefaults.standard.set(url, forKey: "Audio")
                completion("success")
        
            } else if response.response?.statusCode == 503 {
                
            } else {
                completion("failure")
            }
        }
    }
    
    func submitTopic(vc:RootBaseVC,topic:[String],completion:@escaping (String) -> Void) {
        let para = ["topic":topic]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.submitTopic, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                completion("success")
            }
        }
    }
    
    func verifyUsername(vc:RootBaseVC,username:String,completion:@escaping(String,[String]) -> Void) {
        let para = ["username":username]
        APICall.sharedInstance.alamofireCall(url: APIS.verifyUsername, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let message = innerData["message"] as? String ?? ""
                    let suggestions = innerData["suggestions"] as? [String] ?? [""]
                    completion(message,suggestions)
                } else {
                    let error = data["errorMessage"] as! [String:Any]
                    let message = error["message"] as? String
                    let suggestions = data["suggestions"] as? [String] ?? [""]
                    completion(message ?? "",suggestions)
                }
                
            }
        }
    }
    
    func registerUserNew(vc:RootBaseVC,firstName:String,lastName:String,password:String,username:String,gender:String,mobile:String,email:String,status:Bool,dob:String,fcm:String,completion:@escaping (String) -> Void) {
        let para = ["firstName":firstName,"lastName":lastName,"password":password,"username":username,"gender":gender,"mobile":mobile,"email":email,"status":status,"dob":dob,"fcmToken":fcm] as [String : Any]
        APICall.sharedInstance.alamofireCall(url: APIS.register, method: .post, para: para, header: [:], vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let token = innerData["token"] as? String ?? ""
                self.clearDB {
                    self.addToken(token: token) {
                        self.getCurrentUser(vc: RootBaseVC()) { (user) in
                            if user.id == "error" {
                                vc.removeAnimation()
                                vc.showAlert(with: "Message", message: "Something Went Wrong")
                            }
                            completion("success")
                        }
                    }
                }
                
            } else if statusCode == 500 {
                let data = responseData.value as! [String:Any]
                let msg = data["errorMessage"] as? String ?? ""
                vc.removeAnimation()
                vc.showAlert(title: "Message", message: msg)
            } else {
                vc.removeAnimation()
                vc.showAlert(with: "Message", message: "Something Went Wrong")
            }
        }
    }
    
    func getCurrentUser(vc:UIViewController,completion:@escaping (CurrentUser) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        
        APICall.sharedInstance.alamofireCall(url: APIS.currentuser, method: .get, para: "", header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let newUser = innerData["user"] as! [String:Any]
                    let id = newUser["id"] as? String ?? ""
                    let likes = newUser["likes"] as? Int ?? 0
                    let email = newUser["email"] as? String ?? ""
                    let firstName = newUser["firstName"] as? String ?? ""
                    let lastName = newUser["lastName"] as? String ?? ""
                    let mobile = newUser["mobile"] as? Int ?? 0
                    let dob = newUser["dob"] as? String ?? ""
                    let status = newUser["status"] as? Bool ?? false
                    let username = newUser["username"] as? String ?? ""
                    let gender = newUser["gender"] as? String ?? ""
                    let displayPicture = newUser["displayPicture"] as? String ?? ""
                    let about = newUser["about"] as? String ?? ""
                    let totalFollowers = newUser["totalFollowers"] as? Int ?? 0
                    let totalFollowings = newUser["totalFollowings"] as? Int ?? 0
                    let totalPosts = newUser["totalPosts"] as? Int ?? 0
                    let mediaAutoDownload = newUser["mediaAutoDownload"] as? Bool ?? false
                    if Token.sharedInstance.getToken().count != 0 {
                        let t1 = Token()
                        t1.token = Token.sharedInstance.getToken()
                        t1.userid = id
                        t1.username = username
                        self.clearDB {
                            try! self.realm.write {
                                self.realm.add(t1)
                            }
                        }
                    }
                    
                    let tempUser = CurrentUser.init(id: id, likes: likes, email: email, firstName: firstName, lastName: lastName, mobile: mobile, dob: dob, status: status, username: username, gender: gender, dp: displayPicture, about: about, totalFollowers: totalFollowers, totalFollowings: totalFollowings, totalPosts: totalPosts,mediaAutoDownload: mediaAutoDownload)
                    completion(tempUser)
                }
                
            } else {
                completion(CurrentUser.init(id: "error", likes: 0, email: "", firstName: "", lastName: "", mobile: 0, dob: "", status: true, username: "", gender: "", dp: "", about: "", totalFollowers: 0, totalFollowings: 0, totalPosts: 0, mediaAutoDownload: false))
            }
        }
    }
    
    func landingList(vc:RootBaseVC,completion:@escaping ([Landing]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        
        APICall.sharedInstance.alamofireCall(url: APIS.landing, method: .post, para: "", header: header, vc: vc) { (url, responseData, statusCode) in
            var landing = [Landing]()
            if statusCode == 200 {
                guard let data = responseData.value as? [String:Any] else { return }
                guard let innerData = data["data"] as? [String:Any] else {return}
                if let rows = innerData["rows"] as? [[String:Any]]{
                for i in rows {
                    let id = i["id"] as? String ?? ""
                    let url = i["url"] as? String ?? ""
                    let text = i["text"] as? String ?? ""
                    let title = i["title"] as? String ?? ""
                    let status = i["status"] as? Bool ?? true
                    
                    let temp = Landing.init(id: id, url: url, text: text, title: title, status: status, deletedAt: "", createdAt: "", updatedAt: "")
                    if status == true {
                        landing.append(temp)
                    }
                }
            }
                completion(landing)
            }
        }
    }
    
    func getAllPost(vc:RootBaseVC,completion:@escaping ([Post]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.post, method: .post, para: "", header: header, vc: vc) { (url, responseData, statusCode) in
            var all = [Post]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let status = data["code"] as! Int
                if status == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let rows = innerData["rows"] as! [[String:Any]]
                    for i in rows {
                        
                        let id = i["id"] as? String ?? ""
                        let caption = i["caption"] as? String ?? ""
                        let topicid = i["topicId"] as? String ?? ""
                        let userId = i["userId"] as? String ?? ""
                        let createdAt = i["createdAt"] as? String ?? ""
                        let liked = i["liked"] as? Int ?? 0
                        let disliked = i["disliked"] as? Int ?? 0
                        let commentCounts = i["commentCounts"] as? Int ?? 0
                        
                        //MARK:- Media
                        
                        var postElement = [PostElement]()
                        let posts = i["posts"] as? [[String:Any]] ?? [[:]]
                        for j in posts {
                            let postt = j["post"] as? String ?? ""
                            let image = j["image"] as? Int ?? 0
                            postElement.append(.init(post: postt, image: image))
                        }
                        
                        
                        //MARK:- Likes
                        var postLike = [PostCommentElement]()
                        let postLikes = i["postLikes"] as! [[String:Any]]
                        for k in postLikes {
                            let postLikeid = k["id"] as? String ?? ""
                            let postLikepostId = k["postId"] as? String ?? ""
                            let postLikeuserId = k["userId"] as? String ?? ""
                            let postLikeStatus = k["status"] as? Bool ?? true
                            
                            let postLikecreatedAt = k["createdAt"] as? String ?? ""
                            let postLikeUpdatedAt = k["updatedAt"] as? String ?? ""
                            
                            //Post Like USER
                            let postLikeuser = k["user"] as! [String:Any]
                            let postlikeUserID = postLikeuser["id"] as? String ?? ""
                            let postlikeUserName = postLikeuser["username"] as? String ?? ""
                            let postlikeUserDP = postLikeuser["displayPicture"] as? String ?? ""
                            let postLikeUser = PostCommentUser.init(id: postlikeUserID, username: postlikeUserName, displayPicture: postlikeUserDP)
                            
                            var subcommenttemp:SubComment = SubComment.init(id: "", comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user:  PostCommentUser.init(id: "", username: "", displayPicture: ""))
                            if let subcomment = k["subCommentData"] as? [String:Any] {
                                
                                let subid = subcomment["id"] as? String ?? ""
                                let subcommentTxt = subcomment["comment"] as? String ?? ""
                                let subPostid = subcomment["postId"] as? String ?? ""
                                let subUserid = subcomment["userId"] as? String ?? ""
                                let substatus = subcomment["status"] as? Bool ?? false
                                let subcreatedAt = subcomment["createdAt"] as? String ?? ""
                                let subupdatedAt = subcomment["updatedAt"] as? String ?? ""
                                let subuser = subcomment["user"] as! [String:Any]
                                let sub1displayPicture = subuser["displayPicture"] as? String ?? ""
                                let sub1id = subuser["id"] as? String ?? ""
                                let sub1username = subuser["username"] as? String ?? ""
                                let temp = SubComment.init(id: subid, comment: subcommentTxt, subCommentID: "", postID: subPostid, userID: subUserid, status: substatus, deletedAt: "", createdAt: subcreatedAt, updatedAt: subupdatedAt, user: PostCommentUser.init(id: sub1id, username: sub1username, displayPicture: sub1displayPicture))
                                subcommenttemp = temp
                            }
                            
                            postLike.append(PostCommentElement.init(id: postLikeid, comment: "", subCommentID: "", postID: postLikepostId, userID: postLikeuserId, status: postLikeStatus, deletedAt: "", createdAt: postLikecreatedAt, updatedAt: postLikeUpdatedAt, user: postLikeUser, subcomment: subcommenttemp))
                        }
                        
                        //MARK:- Comment
                        var postComment = [PostCommentElement]()
                        let postComments = i["postComments"] as! [[String:Any]]
                        for k in postComments {
                            let postLikeid = k["id"] as? String ?? ""
                            let postLikepostId = k["postId"] as? String ?? ""
                            let postLikeuserId = k["userId"] as? String ?? ""
                            let postLikeStatus = k["status"] as? Bool ?? true
                            let postLikeComment = k["comment"] as? String ?? ""
                            let postLikecreatedAt = k["createdAt"] as? String ?? ""
                            let postLikeUpdatedAt = k["updatedAt"] as? String ?? ""
                            
                            //Post Like USER
                            let postLikeuser = k["user"] as! [String:Any]
                            let postlikeUserID = postLikeuser["id"] as? String ?? ""
                            let postlikeUserName = postLikeuser["username"] as? String ?? ""
                            let postlikeUserDP = postLikeuser["displayPicture"] as? String ?? ""
                            let postLikeUser = PostCommentUser.init(id: postlikeUserID, username: postlikeUserName, displayPicture: postlikeUserDP)
                            
                            var subcommenttemp:SubComment = SubComment.init(id: "", comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user:  PostCommentUser.init(id: "", username: "", displayPicture: ""))
                            if let subcomment = k["subCommentData"] as? [String:Any] {
                                
                                let subid = subcomment["id"] as? String ?? ""
                                let subcommentTxt = subcomment["comment"] as? String ?? ""
                                let subPostid = subcomment["postId"] as? String ?? ""
                                let subUserid = subcomment["userId"] as? String ?? ""
                                let substatus = subcomment["status"] as? Bool ?? false
                                let subcreatedAt = subcomment["createdAt"] as? String ?? ""
                                let subupdatedAt = subcomment["updatedAt"] as? String ?? ""
                                let subuser = subcomment["user"] as! [String:Any]
                                let sub1displayPicture = subuser["displayPicture"] as? String ?? ""
                                let sub1id = subuser["id"] as? String ?? ""
                                let sub1username = subuser["username"] as? String ?? ""
                                let temp = SubComment.init(id: subid, comment: subcommentTxt, subCommentID: "", postID: subPostid, userID: subUserid, status: substatus, deletedAt: "", createdAt: subcreatedAt, updatedAt: subupdatedAt, user: PostCommentUser.init(id: sub1id, username: sub1username, displayPicture: sub1displayPicture))
                                subcommenttemp = temp
                            }
                            
                            postComment.append(PostCommentElement.init(id: postLikeid, comment: postLikeComment, subCommentID: "", postID: postLikepostId, userID: postLikeuserId, status: postLikeStatus, deletedAt: "", createdAt: postLikecreatedAt, updatedAt: postLikeUpdatedAt, user: postLikeUser, subcomment: subcommenttemp))
                        }
                        
                        //MARK:- Post Topic
                        let postTopics = i["topic"] as? [String:Any] ?? [:]
                        let topicID = postTopics["id"] as? String ?? ""
                        let topicName = postTopics["topic"] as? String ?? ""
                        let topicStatus = postTopics["status"] as? Bool ?? true
                        
                        let postTopic = Topic.init(id: topicID, topic: topicName, status: topicStatus, deletedAt: "", createdAt: "", updatedAt: "")
                        
                        
                        //MARK:- Post User
                        let postUser = i["user"] as! [String:Any]
                        let userID = postUser["id"] as? String ?? ""
                        let fname = postUser["topic"] as? String ?? ""
                        let lname = postUser["status"] as? String ?? ""
                        let dob = postUser["dob"] as? String ?? ""
                        let email = postUser["email"] as? String ?? ""
                        let username = postUser["username"] as? String ?? ""
                        let displayPicture = postUser["displayPicture"] as? String ?? ""
                        let mobile = postUser["mobile"] as? Int ?? 0
                        let gender = postUser["gender"] as? String ?? ""
                        
                        let postUserObj = PostUser.init(id: userID, firstName: fname, dob: dob, lastName: lname, email: email, username: username, displayPicture: displayPicture, mobile: mobile, gender: gender, gToken: "", fcmToken: "", fbToken: "", likes: 0, status: true, deletedAt: "", createdAt: "", updatedAt: "")
                        
                        let location = Location.init(type: "", coordinates: [0.0,0.0])
                        let temp = Post.init(id: id, posts: postElement, caption: caption, hashTags: [""], location: location, topicID: topicid, userID: userId, postLikes: postLike, postComments: postComment, topic: postTopic, user: postUserObj, createdAt: createdAt,liked: liked,disliked: disliked,commentCounts:commentCounts)
                        
                        
                        all.append(temp)
                    }
                    completion(all)
                }
            }
        }
    }
    
    func postLike(postId:String,vc:RootBaseVC,completion:@escaping (Int,Int) -> Void) {
        let para = ["postId":postId,"status":true] as [String : Any]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.postLike, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                let innerData = data["data"] as! [String:Any]
                if code == 1 {
                    let likeCount = innerData["likeCount"] as? Int ?? 0
                    let dislikeCount = innerData["dislikeCount"] as? Int ?? 0
                    completion(likeCount,dislikeCount)
                } else {
                    completion(0,0)
                }
            }
        }
    }
    
    func postdisLike(postId:String,vc:RootBaseVC,completion:@escaping (Int,Int) -> Void) {
        let para = ["postId":postId,"status":true] as [String : Any]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.postDislike, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let code = data["code"] as! Int
                if code == 200 {
                    let likeCount = innerData["likeCount"] as? Int ?? 0
                    let dislikeCount = innerData["dislikeCount"] as? Int ?? 0
                    completion(likeCount,dislikeCount)
                } else {
                    completion(0,0)
                }
            }
        }
    }
    
    func postComment(comment:String,postId:String,vc:RootBaseVC,completion:@escaping (String) -> Void) {
        let para = ["postId":postId,"comment":comment,"status":true] as [String : Any]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.postComment, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
        }
    }
    
    func getAllConversation(vc:RootBaseVC,completion:@escaping ([ChatUser]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.chat, method: .post, para: "", header: header, vc: vc) { (url, responseData, statusCode) in
            var all = [ChatUser]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let newUser = innerData["rows"] as! [[String:Any]]
                for i in newUser {
                    let id = i["id"] as? String ?? ""
                    let likes = i["likes"] as? Int ?? 0
                    let email = i["email"] as? String ?? ""
                    let firstName = i["firstName"] as? String ?? ""
                    let lastName = i["lastName"] as? String ?? ""
                    let mobile = i["mobile"] as? Int ?? 0
                    let dob = i["dob"] as? String ?? ""
                    let status = i["status"] as? Bool ?? false
                    let username = i["username"] as? String ?? ""
                    let gender = i["gender"] as? String ?? ""
                    let displayPicture = i["displayPicture"] as? String ?? ""
                    let about = i["about"] as? String ?? ""
                    let isOnline = i["isOnline"] as? Bool ?? false
                    
                    let temp = ChatUser.init(id: id, likes: likes, email: email, firstName: firstName, lastName: lastName, mobile: mobile, dob: dob, status: status, username: username, gender: gender, dp: displayPicture,about: about,isOnline:isOnline)
                    
                    all.append(temp)
                }
                completion(all)
            }
            
        }
    }
    
    func getStory(vc:RootBaseVC,completion:@escaping ([Story]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.story, method: .post, para: "", header: header, vc: vc) { (url, responseData, statusCode) in
            var all = [Story]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let story = innerData["rows"] as! [[String:Any]]
                    for i in story {
                        let createdAt = i["createdAt"] as? String ?? ""
                        let id = i["id"] as? String ?? ""
                        let story = i["story"] as? String ?? ""
                        let caption = i["caption"] as? String ?? ""
                        let topicId = i["topicId"] as? String ?? ""
                        let userId = i["userId"] as? String ?? ""
                        let image = i["image"] as? Bool ?? true
                        let user = i["user"] as! [String:Any]
                        let username = user["username"] as? String ?? ""
                        let displayPicture = user["displayPicture"] as? String ?? ""
                        let about = user["about"] as? String ?? ""
                        
                        let temp = Story.init(createdAt: createdAt, id: id, story: story, caption: caption, hashTags: [""], topicID: topicId, userID: userId, image: image, viewCount: 0, storyViewers: [""], storyUSer: StoryUSer.init(id: "", username: username, firstName: "", lastName: "", email: "", displayPicture: displayPicture))
                        all.append(temp)
                    }
                    completion(all)
                }
                
            }
        }
    }
    
    func insertStory(vc:RootBaseVC, para: [String:Any],completion:@escaping (String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.insertStory, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
//            var all = [Story]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    completion("success")
                }else{
                    completion("failure")
                }
            }
        }
    }
    
    func insertView(vc:RootBaseVC, para: [String:Any],completion:@escaping (String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.insertView, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as? [String:Any] ?? [:]
                let code = data["code"] as! Int
                if code == 1 {
                    completion("success")
                }else{
                    completion("failure")
                }
            }
        }
    }
    
    func chatSetting(vc:RootBaseVC, para: [String:Any],completion:@escaping (String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.chatSetting, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as? [String:Any] ?? [:]
                let code = data["code"] as! Int
                if code == 1 {
                    completion("success")
                }else{
                    completion("failure")
                }
            }
        }
    }
    
    func getChatSetting(vc:RootBaseVC,completion:@escaping ([ChatSetting], String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.getChatSetting, method: .post, para: "", header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                var chat = [ChatSetting]()
                let data = responseData.value as? [String:Any] ?? [:]
                let code = data["code"] as? Int ?? 0
                if code == 1 {
                    let i = data["data"] as? [String: Any] ?? [:]
                        let userId = i["userId"] as? String ?? ""
                        let chatHeadId = i["chatHeadId"] as? String ?? ""
                        let settingType = i["settingType"] as? String ?? ""
                        let id: String = i["id"] as? String ?? ""
                        let markPriority = i["markPriority"] as? Bool ?? false
                        let isNotificationMute = i["isNotificationMute"] as? Bool ?? false
                        let isReported = i["isReported"] as? Bool ?? false
                        let status = i["status"] as? Int ?? 0
                        
                        let temp = ChatSetting.init(userId: userId, chatHeadId: chatHeadId, settingType: settingType, id: id, markPriority: markPriority, isNotificationMute: isNotificationMute, isReported: isReported, status: status)
                        chat.append(temp)
                    completion(chat, "success")
                }else{
                    completion(chat, "failure")
                }
            }
        }
    }

    
    func getMediaLinksAndDocs(vc:RootBaseVC, para: [String:Any],completion:@escaping ([MockMessage], String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.mediaLinksDocs, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            var message = [MockMessage]()
            if statusCode == 200 {
                let data = responseData.value as? [String:Any] ?? [:]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as? [[String:Any]] ?? [[:]]
                    
                    for i in innerData{
                    let attachment =    i["attachment"] as? Int ?? 0
                    let fileURL =       i["fileURL"] as? String ?? ""
                    let attachmentType = i["attachmentType"] as? String ?? ""
                    
                    let temp = MockMessage.init(text: "", user: MockUser.init(senderId: "", displayName: ""), messageId: "", date: Date(), attachment: attachment, createdAt: "", deletedAt: "", id: "", msg: "", status: 0, toUserID: "", updatedAt: "", userID: "", sent: false, senderData: [:], fileURL: fileURL, attachmentType: attachmentType, videothumbnail: "", read: 0)
                        
                        message.append(temp)
                    }
                    completion(message, "success")
                }else{
                    completion(message, "failure")
                }
            }
        }
    }
    
    func getComment(postId:String,vc:RootBaseVC,completion:@escaping ([PostCommentElement]) -> Void) {
        let para = ["postId":postId]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.getComment, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            var postComment = [PostCommentElement]()
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let innerData = data["data"] as! [String:Any]
                let comment = innerData["rows"] as! [[String:Any]]
                for k in comment {
                    let postLikeid = k["id"] as? String ?? ""
                    let postLikepostId = k["postId"] as? String ?? ""
                    let postLikeuserId = k["userId"] as? String ?? ""
                    let postLikeStatus = k["status"] as? Bool ?? true
                    let postLikeComment = k["comment"] as? String ?? ""
                    let postLikecreatedAt = k["createdAt"] as? String ?? ""
                    let postLikeUpdatedAt = k["updatedAt"] as? String ?? ""
//                    let postSubcommentID = k["subCommentId"] as? String ?? ""
                    //Post Like USER
                    let postLikeuser = k["user"] as! [String:Any]
                    let postlikeUserID = postLikeuser["id"] as? String ?? ""
                    let postlikeUserName = postLikeuser["username"] as? String ?? ""
                    let postlikeUserDP = postLikeuser["displayPicture"] as? String ?? ""
//                    var subcommenttemp:SubComment = SubComment.init(id: postSubcommentID, comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user:  PostCommentUser.init(id: "", username: "", displayPicture: ""))
                    var subcommenttemp:SubComment = SubComment.init(id: "", comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user:  PostCommentUser.init(id: "", username: "", displayPicture: ""))
                    if let subcomment = k["subCommentData"] as? [String:Any] {

                        let subid = subcomment["id"] as? String ?? ""
                        let subcommentTxt = subcomment["comment"] as? String ?? ""
                        let subPostid = subcomment["postId"] as? String ?? ""
                        let subUserid = subcomment["userId"] as? String ?? ""
                        let substatus = subcomment["status"] as? Bool ?? false
                        let subcreatedAt = subcomment["createdAt"] as? String ?? ""
                        let subupdatedAt = subcomment["updatedAt"] as? String ?? ""
                        let subuser = subcomment["user"] as! [String:Any]
                        let sub1displayPicture = subuser["displayPicture"] as? String ?? ""
                        let sub1id = subuser["id"] as? String ?? ""
                        let sub1username = subuser["username"] as? String ?? ""
                        let temp = SubComment.init(id: subid, comment: subcommentTxt, subCommentID: "", postID: subPostid, userID: subUserid, status: substatus, deletedAt: "", createdAt: subcreatedAt, updatedAt: subupdatedAt, user: PostCommentUser.init(id: sub1id, username: sub1username, displayPicture: sub1displayPicture))
                        subcommenttemp = temp
                    }
                    let postLikeUser = PostCommentUser.init(id: postlikeUserID, username: postlikeUserName, displayPicture: postlikeUserDP)
                    
                    postComment.append(PostCommentElement.init(id: postLikeid, comment: postLikeComment, subCommentID: "", postID: postLikepostId, userID: postLikeuserId, status: postLikeStatus, deletedAt: "", createdAt: postLikecreatedAt, updatedAt: postLikeUpdatedAt, user: postLikeUser, subcomment: subcommenttemp))
                }
                completion(postComment)
            }
        }
    }
    
    func deleteComment(vc:RootBaseVC,commetnid:String,completion:@escaping (String) -> Void) {
        let para = ["commentId":commetnid]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.deleteComment, method: .post, para: para, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                let data = res.value as! [String:Any]
                
                let success = data["success"] as? Bool ?? false
                if success == true {
                    completion("success")
                } else {
                    completion("failure")
                }
                
            } else if sc == 0 {
                vc.showAlert(with: "Message", message: "Something went wrong")
                vc.removeAnimation()
            }
        }
    }
    
    func likeComment(vc:RootBaseVC,commetnid:String,postId:String,completion:@escaping (String) -> Void) {
        let para = ["commentId":commetnid,"postId":postId,"status":true] as [String : Any]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.commentLike, method: .post, para: para, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                let data = res.value as! [String:Any]
                
                let success = data["success"] as? Bool ?? false
                if success == true {
                    completion("success")
                } else {
                    completion("failure")
                }
                
            } else if sc == 0 {
                vc.showAlert(with: "Message", message: "Something went wrong")
                vc.removeAnimation()
            }
        }
    }
    
    func postSubComment(comment:String,postId:String,subCommentId:String,vc:RootBaseVC,completion:@escaping (String) -> Void) {
        let para = ["postId":postId,"subCommentId":subCommentId,"comment":comment,"status":true] as [String : Any]
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.postComment, method: .post, para: para, header: header, vc: vc) { (url, responseData, statusCode) in
            if statusCode == 200 {
                let data = responseData.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
        }
    }
    
    func fcmupdatee(fcmToken:String) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        let para = ["fcmToken":fcmToken]
        APICall.sharedInstance.alamofireCall(url: APIS.update, method: .post, para: para, header: header, vc: UIViewController()) { (url, res, sc) in
            if sc == 200 {
                print(res)
            }
        }
    }
    
    func createRoomCall(vc:RootBaseVC,recipientId:String,group:Bool,video:Bool,completion:@escaping (RoomID) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        let para = ["recipientId":recipientId,"group":group,"video":video] as [String : Any]
        APICall.sharedInstance.alamofireCall(url: APIS.createRoom, method: .post, para: para, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                let data = res.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let id = innerData["id"] as? String ?? ""
                    let status = innerData["status"] as? Bool ?? false
                    let userId = innerData["userId"] as? String ?? ""
                    let group = innerData["group"] as? Bool ?? false
                    let video = innerData["video"] as? Bool ?? false
                    let createdAt = innerData["createdAt"] as? String ?? ""
                    
                    let temp = RoomID.init(id: id, status: status, userID: userId, group: group, video: video, updatedAt: "", createdAt: createdAt)
                    completion(temp)
                } else {
                    
                }
            }
        }
    }
    
    func getOtherUserProfile(vc:RootBaseVC,userId:String,completion: @escaping (OtherUserr) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        let para = ["userId":userId]
        APICall.sharedInstance.alamofireCall(url: APIS.otherUser, method: .post, para: para, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                let data = res.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let main = data["data"] as! [String:Any]
                    let user = main["user"] as! [String:Any]
                    let dob = user["dob"] as? String ?? ""
                    let displayPicture = user["displayPicture"] as? String ?? ""
                    let isOnline = user["isOnline"] as? Bool ?? false
                    let lastLoggedIn = user["lastLoggedIn"] as? String ?? ""
                    let ip = user["ip"] as? String ?? ""
                    let ios = user["ios"] as? String ?? ""
                    let about = user["about"] as? String ?? ""
                    let id = user["id"] as? String ?? ""
                    let firstName = user["firstName"] as? String ?? ""
                    let lastName = user["lastName"] as? String ?? ""
                    let email = user["email"] as? String ?? ""
                    let username = user["username"] as? String ?? ""
                    let mobile = user["mobile"] as? Int ?? 0
                    let gender = user["gender"] as? String ?? ""
                    let status = user["status"] as? Bool ?? false
                    let createdAt = user["createdAt"] as? String ?? ""
                    let accountType = user["accountType"] as? String ?? ""
                    let likes = user["likes"] as? Int ?? 0
                    let totalFollowers = user["totalFollowers"] as? Int ?? 0
                    let totalFollowings = user["totalFollowings"] as? Int ?? 0
                    let totalPosts = user["totalPosts"] as? Int ?? 0
                    let friendStatus = user["friendStatus"] as? String ?? ""
                    var allPost = [Post]()
                    
                    if let posts = user["posts"] as? [[String:Any]] {
                        for i in posts {
                            let id = i["id"] as? String ?? ""
                            let caption = i["caption"] as? String ?? ""
                            let topicid = i["topicId"] as? String ?? ""
                            let userId = i["userId"] as? String ?? ""
                            let createdAt = i["createdAt"] as? String ?? ""
                            let liked = i["liked"] as? Int ?? 0
                            let disliked = i["disliked"] as? Int ?? 0
                            let commentCounts = i["commentCounts"] as? Int ?? 0
                            
                            //MARK:- Media
                            
                            var postElement = [PostElement]()
                            let posts = i["posts"] as! [[String:Any]]
                            for j in posts {
                                let postt = j["post"] as? String ?? ""
                                let image = j["image"] as? Int ?? 0
                                postElement.append(.init(post: postt, image: image))
                            }
                            
                            
                            //MARK:- Likes
                            var postLike = [PostCommentElement]()
                            let postLikes = i["postLikes"] as! [[String:Any]]
                            for k in postLikes {
                                let postLikeid = k["id"] as? String ?? ""
                                let postLikepostId = k["postId"] as? String ?? ""
                                let postLikeuserId = k["userId"] as? String ?? ""
                                let postLikeStatus = k["status"] as? Bool ?? true
                                
                                let postLikecreatedAt = k["createdAt"] as? String ?? ""
                                let postLikeUpdatedAt = k["updatedAt"] as? String ?? ""
                                
                                //Post Like USER
                                let postLikeuser = k["user"] as! [String:Any]
                                let postlikeUserID = postLikeuser["id"] as? String ?? ""
                                let postlikeUserName = postLikeuser["username"] as? String ?? ""
                                let postlikeUserDP = postLikeuser["displayPicture"] as? String ?? ""
                                let postLikeUser = PostCommentUser.init(id: postlikeUserID, username: postlikeUserName, displayPicture: postlikeUserDP)
                                
                                var subcommenttemp:SubComment = SubComment.init(id: "", comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user:  PostCommentUser.init(id: "", username: "", displayPicture: ""))
                                if let subcomment = k["subCommentData"] as? [String:Any] {
                                    
                                    let subid = subcomment["id"] as? String ?? ""
                                    let subcommentTxt = subcomment["comment"] as? String ?? ""
                                    let subPostid = subcomment["postId"] as? String ?? ""
                                    let subUserid = subcomment["userId"] as? String ?? ""
                                    let substatus = subcomment["status"] as? Bool ?? false
                                    let subcreatedAt = subcomment["createdAt"] as? String ?? ""
                                    let subupdatedAt = subcomment["updatedAt"] as? String ?? ""
                                    let subuser = subcomment["user"] as! [String:Any]
                                    let sub1displayPicture = subuser["displayPicture"] as? String ?? ""
                                    let sub1id = subuser["id"] as? String ?? ""
                                    let sub1username = subuser["username"] as? String ?? ""
                                    let temp = SubComment.init(id: subid, comment: subcommentTxt, subCommentID: "", postID: subPostid, userID: subUserid, status: substatus, deletedAt: "", createdAt: subcreatedAt, updatedAt: subupdatedAt, user: PostCommentUser.init(id: sub1id, username: sub1username, displayPicture: sub1displayPicture))
                                    subcommenttemp = temp
                                }
                                
                                postLike.append(PostCommentElement.init(id: postLikeid, comment: "", subCommentID: "", postID: postLikepostId, userID: postLikeuserId, status: postLikeStatus, deletedAt: "", createdAt: postLikecreatedAt, updatedAt: postLikeUpdatedAt, user: postLikeUser, subcomment: subcommenttemp))
                            }
                            
                            //MARK:- Comment
                            var postComment = [PostCommentElement]()
                            let postComments = i["postComments"] as! [[String:Any]]
                            
                            for k in postComments {
                                let postLikeid = k["id"] as? String ?? ""
                                let postLikepostId = k["postId"] as? String ?? ""
                                let postLikeuserId = k["userId"] as? String ?? ""
                                let postLikeStatus = k["status"] as? Bool ?? true
                                let postLikeComment = k["comment"] as? String ?? ""
                                let postLikecreatedAt = k["createdAt"] as? String ?? ""
                                let postLikeUpdatedAt = k["updatedAt"] as? String ?? ""
                                
                                //Post Like USER
                                let postLikeuser = k["user"] as! [String:Any]
                                let postlikeUserID = postLikeuser["id"] as? String ?? ""
                                let postlikeUserName = postLikeuser["username"] as? String ?? ""
                                let postlikeUserDP = postLikeuser["displayPicture"] as? String ?? ""
                                let postLikeUser = PostCommentUser.init(id: postlikeUserID, username: postlikeUserName, displayPicture: postlikeUserDP)
                                
                                var subcommenttemp:SubComment = SubComment.init(id: "", comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user:  PostCommentUser.init(id: "", username: "", displayPicture: ""))
                                
                                if let subcomment = k["subCommentData"] as? [String:Any] {
                                    
                                    let subid = subcomment["id"] as? String ?? ""
                                    let subcommentTxt = subcomment["comment"] as? String ?? ""
                                    let subPostid = subcomment["postId"] as? String ?? ""
                                    let subUserid = subcomment["userId"] as? String ?? ""
                                    let substatus = subcomment["status"] as? Bool ?? false
                                    let subcreatedAt = subcomment["createdAt"] as? String ?? ""
                                    let subupdatedAt = subcomment["updatedAt"] as? String ?? ""
                                    let subuser = subcomment["user"] as! [String:Any]
                                    let sub1displayPicture = subuser["displayPicture"] as? String ?? ""
                                    let sub1id = subuser["id"] as? String ?? ""
                                    let sub1username = subuser["username"] as? String ?? ""
                                    let temp = SubComment.init(id: subid, comment: subcommentTxt, subCommentID: "", postID: subPostid, userID: subUserid, status: substatus, deletedAt: "", createdAt: subcreatedAt, updatedAt: subupdatedAt, user: PostCommentUser.init(id: sub1id, username: sub1username, displayPicture: sub1displayPicture))
                                    subcommenttemp = temp
                                }
                                
                                postComment.append(PostCommentElement.init(id: postLikeid, comment: postLikeComment, subCommentID: "", postID: postLikepostId, userID: postLikeuserId, status: postLikeStatus, deletedAt: "", createdAt: postLikecreatedAt, updatedAt: postLikeUpdatedAt, user: postLikeUser, subcomment: subcommenttemp))
                            }
                            
                            var topicPost:Topic = Topic.init(id: "", topic: "", status: false, deletedAt: "", createdAt: "", updatedAt: "")
                            //MARK:- Post Topic
                            if let postTopics = i["topic"] as? [String:Any] {
                                let topicID = postTopics["id"] as? String ?? ""
                                let topicName = postTopics["topic"] as? String ?? ""
                                let topicStatus = postTopics["status"] as? Bool ?? true
                                
                                let postTopic = Topic.init(id: topicID, topic: topicName, status: topicStatus, deletedAt: "", createdAt: "", updatedAt: "")
                                topicPost = postTopic
                            }
                            
                            
                            
                            //MARK:- Post User
                            var postUserr:PostUser = PostUser.init(id: "", firstName: "", dob: "", lastName: "", email: "", username: "", displayPicture: "", mobile: 1, gender: "", gToken: "", fcmToken: "", fbToken: "", likes: 1, status: false, deletedAt: "", createdAt: "", updatedAt: "")
                            if let postUser = i["user"] as? [String:Any] {
                                let userID = postUser["id"] as? String ?? ""
                                let fname = postUser["topic"] as? String ?? ""
                                let lname = postUser["status"] as? String ?? ""
                                let dob = postUser["dob"] as? String ?? ""
                                let email = postUser["email"] as? String ?? ""
                                let username = postUser["username"] as? String ?? ""
                                let displayPicture = postUser["displayPicture"] as? String ?? ""
                                let mobile = postUser["mobile"] as? Int ?? 0
                                let gender = postUser["gender"] as? String ?? ""
                                
                                let postUserObj = PostUser.init(id: userID, firstName: fname, dob: dob, lastName: lname, email: email, username: username, displayPicture: displayPicture, mobile: mobile, gender: gender, gToken: "", fcmToken: "", fbToken: "", likes: 0, status: true, deletedAt: "", createdAt: "", updatedAt: "")
                                
                                postUserr = postUserObj
                            }
                            
                            
                            
                            
                            let location = Location.init(type: "", coordinates: [0.0,0.0])
                            let temp = Post.init(id: id, posts: postElement, caption: caption, hashTags: [""], location: location, topicID: topicid, userID: userId, postLikes: postLike, postComments: postComment, topic: topicPost, user: postUserr, createdAt: createdAt,liked: liked,disliked: disliked,commentCounts:commentCounts)
                            
                            
                            
                            allPost.append(temp)
                        }
                    }
                    
                    
                    let temp = OtherUserr.init(dob: dob, displayPicture: displayPicture, isOnline: isOnline, lastLoggedIn: lastLoggedIn, ip: ip, ios: ios, about: about, id: id, firstName: firstName, lastName: lastName, email: email, username: username, mobile: mobile, gender: gender, status: status, createdAt: createdAt, accountType: accountType, likes: likes, totalFollowers: totalFollowers, totalFollowings: totalFollowings, totalPosts: totalPosts, posts: allPost, follows: [""],friendStatus:friendStatus)
                    
                    completion(temp)
                } else {
                    
                }
            }
        }
    }
    
    func getAllSuggestion(vc:RootBaseVC,completion:@escaping ([SuggestedUser]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        APICall.sharedInstance.alamofireCall(url: APIS.suggestionUser, method: .get, para: "", header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                var all = [SuggestedUser]()
                let data = res.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [[String:Any]]
                    for i in innerData {
                        let id = i["id"] as? String ?? ""
                        let firstName = i["firstName"] as? String ?? ""
                        let lastName = i["lastName"] as? String ?? ""
                        let displayPicture = i["displayPicture"] as? String ?? ""
                        let email = i["email"] as? String ?? ""
                        let username = i["username"] as? String ?? ""
                        let mobile = i["mobile"] as? Int ?? 0
                        let password = i["password"] as? String ?? ""
                        let gender = i["gender"] as? String ?? ""
                        let gTOken = i["gTOken"] as? String ?? ""
                        let fbToken = i["fbToken"] as? String ?? ""
                        let likes = i["likes"] as? Int ?? 0
                        let status = i["status"] as? Int ?? 0
                        let deletedAt = i["deletedAt"] as? String ?? ""
                        let createdAt = i["createdAt"] as? String ?? ""
                        let updatedAt = i["updatedAt"] as? String ?? ""
                        let otp = i["otp"] as? String ?? ""
                        let otpExpires = i["otpExpires"] as? String ?? ""
                        let fcmToken = i["fcmToken"] as? String ?? ""
                        let dob = i["dob"] as? String ?? ""
                        let isOnline = i["isOnline"] as? Bool ?? false
                        let lastLoggedIn = i["lastLoggedIn"] as? String ?? ""
                        let ip = i["ip"] as? String ?? ""
                        let ios = i["ios"] as? String ?? ""
                        let about = i["about"] as? String ?? ""
                        let accountType = i["accountType"] as? String ?? ""
                        let deviceVoipToken = i["deviceVoipToken"] as? String ?? ""
                        let adharFront = i["adharFront"] as? String ?? ""
                        let adharBack = i["adharBack"] as? String ?? ""
                        let adharNumber = i["adharNumber"] as? String ?? ""
                        let isAdharVerified = i["isAdharVerified"] as? Int ?? 0
                        let lat = i["lat"] as? String ?? ""
                        let lag = i["lag"] as? String ?? ""
                        
                        all.append(SuggestedUser.init(id: id, firstName: firstName, lastName: lastName, displayPicture: displayPicture, email: email, username: username, mobile: mobile, password: password, gender: gender, gTOken: gTOken, fbToken: fbToken, likes: likes, status: status, deletedAt: deletedAt, createdAt: createdAt, updatedAt: updatedAt, otp: otp, otpExpires: otpExpires, fcmToken: fcmToken, dob: dob, isOnline: isOnline, lastLoggedIn: lastLoggedIn, ip: ip, ios: ios, about: about, accountType: accountType, deviceVoipToken: deviceVoipToken, adharFront: adharFront, adharBack: adharBack, adharNumber: adharNumber, isAdharVerified: isAdharVerified, lat: lat, lag: lag))
                    }
                    completion(all)
                } else {
                    
                }
            }
        }
    }
    
    func getFollowsData(userId:String,vc:RootBaseVC,completion:@escaping ([SuggestedUser],[SuggestedUser],String,String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        let para = ["userId":userId]
        APICall.sharedInstance.alamofireCall(url: APIS.getFollowData, method: .post, para: para, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                var followerArr = [SuggestedUser]()
                var followingArr = [SuggestedUser]()
                let data = res.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [String:Any]
                    let user = innerData["user"] as! [String:Any]
                    let displayPicture = user["displayPicture"] as? String ?? ""
                    let username = user["username"] as? String ?? ""
                    let follower = innerData["follower"] as! [[String:Any]]
                    
                    for i in follower {
                        let followerData = i
                        let id = followerData["id"] as? String ?? ""
                        let firstName = followerData["firstName"] as? String ?? ""
                        let lastName = followerData["lastName"] as? String ?? ""
                        let displayPicture = followerData["displayPicture"] as? String ?? ""
                        let email = followerData["email"] as? String ?? ""
                        let username = followerData["username"] as? String ?? ""
                        let mobile = followerData["mobile"] as? Int ?? 0
                        let password = followerData["password"] as? String ?? ""
                        let gender = followerData["gender"] as? String ?? ""
                        let gTOken = followerData["gTOken"] as? String ?? ""
                        let fbToken = followerData["fbToken"] as? String ?? ""
                        let likes = followerData["likes"] as? Int ?? 0
                        let status = followerData["status"] as? Int ?? 0
                        let deletedAt = followerData["deletedAt"] as? String ?? ""
                        let createdAt = followerData["createdAt"] as? String ?? ""
                        let updatedAt = followerData["updatedAt"] as? String ?? ""
                        let otp = followerData["otp"] as? String ?? ""
                        let otpExpires = followerData["otpExpires"] as? String ?? ""
                        let fcmToken = followerData["fcmToken"] as? String ?? ""
                        let dob = followerData["dob"] as? String ?? ""
                        let isOnline = followerData["isOnline"] as? Bool ?? false
                        let lastLoggedIn = followerData["lastLoggedIn"] as? String ?? ""
                        let ip = followerData["ip"] as? String ?? ""
                        let ios = followerData["ios"] as? String ?? ""
                        let about = followerData["about"] as? String ?? ""
                        let accountType = followerData["accountType"] as? String ?? ""
                        let deviceVoipToken = followerData["deviceVoipToken"] as? String ?? ""
                        let adharFront = followerData["adharFront"] as? String ?? ""
                        let adharBack = followerData["adharBack"] as? String ?? ""
                        let adharNumber = followerData["adharNumber"] as? String ?? ""
                        let isAdharVerified = followerData["isAdharVerified"] as? Int ?? 0
                        let lat = followerData["lat"] as? String ?? ""
                        let lag = followerData["lag"] as? String ?? ""
                        
                        followerArr.append(SuggestedUser.init(id: id, firstName: firstName, lastName: lastName, displayPicture: displayPicture, email: email, username: username, mobile: mobile, password: password, gender: gender, gTOken: gTOken, fbToken: fbToken, likes: likes, status: status, deletedAt: deletedAt, createdAt: createdAt, updatedAt: updatedAt, otp: otp, otpExpires: otpExpires, fcmToken: fcmToken, dob: dob, isOnline: isOnline, lastLoggedIn: lastLoggedIn, ip: ip, ios: ios, about: about, accountType: accountType, deviceVoipToken: deviceVoipToken, adharFront: adharFront, adharBack: adharBack, adharNumber: adharNumber, isAdharVerified: isAdharVerified, lat: lat, lag: lag))
                    }
                    let following = innerData["following"] as! [[String:Any]]
                    
                    for i in following {
                        let followerData = i
                        let id = followerData["id"] as? String ?? ""
                        let firstName = followerData["firstName"] as? String ?? ""
                        let lastName = followerData["lastName"] as? String ?? ""
                        let displayPicture = followerData["displayPicture"] as? String ?? ""
                        let email = followerData["email"] as? String ?? ""
                        let username = followerData["username"] as? String ?? ""
                        let mobile = followerData["mobile"] as? Int ?? 0
                        let password = followerData["password"] as? String ?? ""
                        let gender = followerData["gender"] as? String ?? ""
                        let gTOken = followerData["gTOken"] as? String ?? ""
                        let fbToken = followerData["fbToken"] as? String ?? ""
                        let likes = followerData["likes"] as? Int ?? 0
                        let status = followerData["status"] as? Int ?? 0
                        let deletedAt = followerData["deletedAt"] as? String ?? ""
                        let createdAt = followerData["createdAt"] as? String ?? ""
                        let updatedAt = followerData["updatedAt"] as? String ?? ""
                        let otp = followerData["otp"] as? String ?? ""
                        let otpExpires = followerData["otpExpires"] as? String ?? ""
                        let fcmToken = followerData["fcmToken"] as? String ?? ""
                        let dob = followerData["dob"] as? String ?? ""
                        let isOnline = followerData["isOnline"] as? Bool ?? false
                        let lastLoggedIn = followerData["lastLoggedIn"] as? String ?? ""
                        let ip = followerData["ip"] as? String ?? ""
                        let ios = followerData["ios"] as? String ?? ""
                        let about = followerData["about"] as? String ?? ""
                        let accountType = followerData["accountType"] as? String ?? ""
                        let deviceVoipToken = followerData["deviceVoipToken"] as? String ?? ""
                        let adharFront = followerData["adharFront"] as? String ?? ""
                        let adharBack = followerData["adharBack"] as? String ?? ""
                        let adharNumber = followerData["adharNumber"] as? String ?? ""
                        let isAdharVerified = followerData["isAdharVerified"] as? Int ?? 0
                        let lat = followerData["lat"] as? String ?? ""
                        let lag = followerData["lag"] as? String ?? ""
                        
                        followingArr.append(SuggestedUser.init(id: id, firstName: firstName, lastName: lastName, displayPicture: displayPicture, email: email, username: username, mobile: mobile, password: password, gender: gender, gTOken: gTOken, fbToken: fbToken, likes: likes, status: status, deletedAt: deletedAt, createdAt: createdAt, updatedAt: updatedAt, otp: otp, otpExpires: otpExpires, fcmToken: fcmToken, dob: dob, isOnline: isOnline, lastLoggedIn: lastLoggedIn, ip: ip, ios: ios, about: about, accountType: accountType, deviceVoipToken: deviceVoipToken, adharFront: adharFront, adharBack: adharBack, adharNumber: adharNumber, isAdharVerified: isAdharVerified, lat: lat, lag: lag))
                    }
                    completion(followerArr,followingArr,displayPicture,username)
                } else {
                    
                }
            }
        }
    }
    
    func followGetFriends(vc:RootBaseVC,completion:@escaping ([SuggestedUser]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        //let parameter = ["userId":userId, "toUserId": toUserId]
        APICall.sharedInstance.alamofireCall(url: APIS.followGetFriends, method: .post, para: "", header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                var all = [SuggestedUser]()
                let data = res.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [[String:Any]]
                    for i in innerData {
                        let id = i["id"] as? String ?? ""
                        let firstName = i["firstName"] as? String ?? ""
                        let lastName = i["lastName"] as? String ?? ""
                        let displayPicture = i["displayPicture"] as? String ?? ""
                        let email = i["email"] as? String ?? ""
                        let username = i["username"] as? String ?? ""
                        let mobile = i["mobile"] as? Int ?? 0
                        let password = i["password"] as? String ?? ""
                        let gender = i["gender"] as? String ?? ""
                        let gTOken = i["gTOken"] as? String ?? ""
                        let fbToken = i["fbToken"] as? String ?? ""
                        let likes = i["likes"] as? Int ?? 0
                        let status = i["status"] as? Int ?? 0
                        let deletedAt = i["deletedAt"] as? String ?? ""
                        let createdAt = i["createdAt"] as? String ?? ""
                        let updatedAt = i["updatedAt"] as? String ?? ""
                        let otp = i["otp"] as? String ?? ""
                        let otpExpires = i["otpExpires"] as? String ?? ""
                        let fcmToken = i["fcmToken"] as? String ?? ""
                        let dob = i["dob"] as? String ?? ""
                        let isOnline = i["isOnline"] as? Bool ?? false
                        let lastLoggedIn = i["lastLoggedIn"] as? String ?? ""
                        let ip = i["ip"] as? String ?? ""
                        let ios = i["ios"] as? String ?? ""
                        let about = i["about"] as? String ?? ""
                        let accountType = i["accountType"] as? String ?? ""
                        let deviceVoipToken = i["deviceVoipToken"] as? String ?? ""
                        let adharFront = i["adharFront"] as? String ?? ""
                        let adharBack = i["adharBack"] as? String ?? ""
                        let adharNumber = i["adharNumber"] as? String ?? ""
                        let isAdharVerified = i["isAdharVerified"] as? Int ?? 0
                        let lat = i["lat"] as? String ?? ""
                        let lag = i["lag"] as? String ?? ""
                        
                        all.append(SuggestedUser.init(id: id, firstName: firstName, lastName: lastName, displayPicture: displayPicture, email: email, username: username, mobile: mobile, password: password, gender: gender, gTOken: gTOken, fbToken: fbToken, likes: likes, status: status, deletedAt: deletedAt, createdAt: createdAt, updatedAt: updatedAt, otp: otp, otpExpires: otpExpires, fcmToken: fcmToken, dob: dob, isOnline: isOnline, lastLoggedIn: lastLoggedIn, ip: ip, ios: ios, about: about, accountType: accountType, deviceVoipToken: deviceVoipToken, adharFront: adharFront, adharBack: adharBack, adharNumber: adharNumber, isAdharVerified: isAdharVerified, lat: lat, lag: lag))
                    }
                    completion(all)
                } else {
                    
                }
            }
        }
    }
    
    func getGroupMembers(vc:RootBaseVC,groupId: String ,completion:@escaping ([GroupMember]) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        let parameter = ["groupId":groupId]
        APICall.sharedInstance.alamofireCall(url: APIS.getGroupMember, method: .post, para: parameter, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                var all = [GroupMember]()
                let data = res.value as! [String:Any]
                let code = data["code"] as! Int
                if code == 1 {
                    let innerData = data["data"] as! [[String:Any]]
                    for i in innerData {
                        let id = i["id"] as? String ?? ""
                        let groupId = i["groupId"] as? String ?? ""
                        let user = i["user"] as? [String: Any] ?? [:]
                            let lastName = user["lastName"] as? String ?? ""
                            let displayPicture = user["displayPicture"] as? String ?? ""
                            let firstName = user["firstName"] as? String ?? ""
                            let username = user["username"] as? String ?? ""
                            let userid = user["id"] as? String ?? ""
                                                
                        all.append(GroupMember.init(groupId: groupId, id: id, displayPicture: displayPicture, firstName: firstName, userid: userid, lastName: lastName, username: username))
                    }
                    completion(all)
                } else {
                    
                }
            }
        }
    }

    
    func getGroupChatHeads(vc:RootBaseVC,para: [String: Any],completion:@escaping (String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        //let parameter = ["userId":userId, "toUserId": toUserId]
        APICall.sharedInstance.alamofireCall(url: APIS.getGroupChatHeads, method: .post, para: para, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                let data = res.value as? [String:Any] ?? [:]
                let code = data["code"] as? Int ?? 0
                if code == 1  {
                    completion("success")
                }else{
                    completion("failure")
                }
            }
        }
    }
    
    func updateGroup(vc:RootBaseVC,para: [String: Any],completion:@escaping (String) -> Void) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        //let parameter = ["userId":userId, "toUserId": toUserId]
        APICall.sharedInstance.alamofireCall(url: APIS.updateGroup, method: .post, para: para, header: header, vc: vc) { (url, res, sc) in
            if sc == 200 {
                let data = res.value as? [String:Any] ?? [:]
                let code = data["code"] as? Int ?? 0
                if code == 1  {
                    completion("success")
                }else{
                    completion("failure")
                }
            }
        }
    }
    

    
    func postPhoto(postData:[PostData]) {
        let header:HTTPHeaders = ["x-token":Token.sharedInstance.getToken()]
        var postPara = [""]
        for i in postData {
            
        }
    }
    
}
//vc:RootBaseVC,
/*
 if sc == 200 {
 let data = res.value as! [String:Any]
 let code = data["code"] as! Int
 if code == 1 {
 
 } else {
 
 }
 }
 */

open class SocketSessionHandler: NSObject, URLSessionDelegate {
    
    static var manager = SocketManager(socketURL: URL(string:"https://socket.dbmdemo.com")!, config:  [.compress,.log(true), .reconnects(true), .selfSigned(true)])

        override init() {
            super.init()
            SocketSessionHandler.manager.config.insert(.sessionDelegate(self))
        }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.host == "socket.dbmdemo.com" {
                completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
    }
}


