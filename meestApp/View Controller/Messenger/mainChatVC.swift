//
//  mainChatVC.swift
//  meestApp
//
//  Created by Yash on 8/30/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import SocketIO
import Kingfisher
import MessageKit
import IHKeyboardAvoiding

class mainChatVC: RootBaseVC {

    @IBOutlet weak var headerView:UIView!
  //  @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var txtView:UIView!
    @IBOutlet weak var sendBtn:UIButton!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var msgTxtView:UITextView!
    @IBOutlet weak var tableView:chatTblView!
    
    var userid = ""
    var count = 0
    var toUser:ChatHeads?
    var messages = [MockMessage]()
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
     //   self.txtView.cornerRadius(radius: self.txtView.frame.height / 2)
     //   self.sendBtn.cornerRadius(radius: self.sendBtn.frame.height / 2)
        self.img.cornerRadius(radius: self.img.frame.height / 2)
        
        
     //   self.msgTxtView.textColor = UIColor.gray
     //   self.msgTxtView.text = "Type your message"
    //    self.msgTxtView.delegate = self
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.socket = APIManager.sharedInstance.getSocket()
        self.addHandler()
        self.tableView.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            self.userid = user.id
            let neww = ["userId":user.id,"chatHeadId":self.toUser?.chatHeadId ?? ""] as [String : Any]
            self.socket.emitWithAck("get_history", neww).timingOut(after: 20) {data in
                return
            }
        }
        self.nameLbl.text = (self.toUser?.firstName ?? "") + " " + (self.toUser?.lastName ?? "")
        self.img.kf.indicatorType = .activity
        self.img.kf.setImage(with: URL(string: self.toUser?.dp),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(self.toUser?.dp)
                print("Job failed: \(error.localizedDescription)")
            }
        }
        self.tableView.toUser = self.toUser
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func sendmsg(_ sender:UIButton) {
       
        self.msgTxtView.text = ""
        self.view.endEditing(true)
        
    }
    func addHandler() {
        
        self.socket.on("message") { (dataa, ack) in
            print(dataa)
            var ChatUserID = ""
            let ChatUserName = ""
            let datamsg = dataa as! [[String:Any]]
            let data = datamsg[0]["msg"] as! [String:Any]
            let attachment = data["attachment"] as? Int ?? 0
            let createdAt = data["createdAt"] as? String ?? ""
            let deletedAt = data["deletedAt"] as? String ?? ""
            let id = data["id"] as? String ?? ""
            let msg = data["msg"] as? String ?? ""
            let status = data["status"] as? Int ?? 0
            let toUserId = data["toUserId"] as? String ?? ""
            let updatedAt = data["updatedAt"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""
            let sent = data["sender"] as? Bool ?? false
            if sent {
                
                ChatUserID = self.toUser?.id ?? ""
            } else {
                ChatUserID = self.userid
                
            }
            let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent, senderData: [:])
            
            self.messages.append(temp)
            
            self.tableView.reloadData()
        }
        
        self.socket.on("chat_history") { (dataa, ack) in
            self.messages.removeAll()
            print(dataa)
//            let data = dataa as! [[String:Any]]
//            let count = data[0]["count"] as? Int ?? 0
//            self.count = count
            let rows = dataa[0] as! [[String:Any]]
            for ii in rows {
                var ChatUserID = ""
                let ChatUserName = ""
                let attachment = ii["attachment"] as? Int ?? 0
                let createdAt = ii["createdAt"] as? String ?? ""
                let deletedAt = ii["deletedAt"] as? String ?? ""
                let id = ii["id"] as? String ?? ""
                let msg = ii["msg"] as? String ?? ""
                let status = ii["status"] as? Int ?? 0
                let toUserId = ii["toUserId"] as? String ?? ""
                let updatedAt = ii["updatedAt"] as? String ?? ""
                let userId = ii["userId"] as? String ?? ""
                let sent = ii["sender"] as? Bool ?? false
                let senderData = ii["senderData"] as? [String: Any] ?? [:]
                if sent {
                    ChatUserID = self.userid
                    
                } else {
                    ChatUserID = self.toUser?.id ?? ""
                }
                let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent, senderData: senderData)
                
                self.messages.append(temp)
            }
            self.tableView.reloadData()
        }
    }
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    @IBAction func sendMsg(_ sender:UIButton) {
        let new = ["msg":self.msgTxtView.text ?? "","toUserId":self.toUser?.id ?? "","type":0,"userId":self.userid] as [String : Any]
        
        self.messages.append(MockMessage.init(text: self.msgTxtView.text ?? "", user: MockUser.init(senderId: self.toUser?.id ?? "", displayName: ""), messageId: "", date: Date(), attachment: 0, createdAt: "", deletedAt: "", id: "", msg: self.msgTxtView.text ?? "", status: 0, toUserID: self.toUser?.id ?? "", updatedAt: "", userID: "", sent: true,senderData: [:]))
        self.msgTxtView.text = ""
        
        self.socket.emitWithAck("send", new).timingOut(after: 20) {data in
            print(data)
            return
        }
        
    }
}
extension mainChatVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.text = ""
        textView.textColor = UIColor.black
        
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            self.sendBtn.setImage(UIImage.init(named: "microphone"), for: .normal)
        } else {
            self.sendBtn.setImage(UIImage.init(named: "navigation"), for: .normal)
        }
    }
}
extension mainChatVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messages[indexPath.row].sent == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! msgSenderCell
            let ind = self.messages[indexPath.row]
            cell.view1.cornerRadius(radius: 13)
            cell.txt1.text = ind.msg
            cell.sentimg.image = UIImage.init(named: "sent")
            cell.view1.backgroundColor = UIColor.init(hex: 0x3B5998)
            cell.txt1.textColor = UIColor.white
            cell.txt1.font = UIFont.init(name: APPFont.semibold, size: 16)
//            cell.img.kf.indicatorType = .activity
//            cell.img.kf.setImage(with: URL(string: ind.senderData["displayPicture"] as? String),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
//                switch result {
//                case .success(let value):
//                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//
//                case .failure(let error):
////                    print(ind.dp)
//                    print("Job failed: \(error.localizedDescription)")
//
//                }
//            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! msgReceiverCell
            let ind = self.messages[indexPath.row]
            cell.view1.cornerRadius(radius: 13)
            cell.txt1.text = ind.msg
//            cell.sentimg.image = UIImage.init(named: "sent")
            cell.view1.backgroundColor = UIColor.init(hex: 0x3B5998)
            cell.txt1.textColor = UIColor.init(hex: 0x354052)
            cell.txt1.font = UIFont.init(name: APPFont.semibold, size: 16)
//            cell.img.kf.indicatorType = .activity
//            let url = ind.senderData["displayPicture"] as? String
//            cell.img.kf.setImage(with: URL(string: url ?? ""),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
//                switch result {
//                case .success(let value):
//                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//
//                case .failure(let error):
//                    print(ind.senderData["displayPicture"])
//                    print("Job failed: \(error.localizedDescription)")
//
//                }
//            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
class msgSenderCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var sentimg:UIImageView!
    @IBOutlet weak var timelbl:UILabel!
    
}
class msgReceiverCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var sentimg:UIImageView!
    @IBOutlet weak var timelbl:UILabel!
    @IBOutlet weak var proImg:UIImageView!
}

