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
import AVKit
import AVFoundation

class mainChatVC: RootBaseVC {

    @IBOutlet weak var headerView:UIView!
  //  @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var txtView:UIView!
    @IBOutlet weak var sendBtn:UIButton!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var msgTxtView:UITextView!
    @IBOutlet weak var tableView:chatTblView!
    @IBOutlet var typingLabel: UILabel!
    
    var userid = ""
    var count = 0
    var toUser:ChatHeads?
    var messages = [MockMessage]()
    var socket:SocketIOClient!
//    var attachmentButtonClicked : (()->())!
    var playerController : AVPlayerViewController!
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
//        tableView.attachmentButtonClicked = {
//            print("Attachment Button clicked")
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(attachmentButtonClicked), name: Notification.Name.init(rawValue: "attachmentButtonClicked"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.typingLabel.text = ""
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
        
        self.socket.on("friend_typing") { data, ack in
            print(data)
            let chatHeadID = data[0] as! [String:Any]
            let chatID = chatHeadID["chatHeadId"] as? String ?? ""
            let userID = chatHeadID["userId"] as? String ?? ""
            if self.toUser?.chatHeadId == chatID && self.userid != userID{
                self.typingLabel.text = "typing..."
            }else{
                self.typingLabel.text = ""
            }
        }
        
        self.socket.on("sent") { data, ack in
            print(data)
            APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
                self.userid = user.id
                let neww = ["userId":user.id,"chatHeadId":self.toUser?.chatHeadId ?? ""] as [String : Any]
                self.socket.emit("get_history", neww)
            }
            
        }
        self.socket.on("message") { (dataa, ack) in
            print(dataa)
            var ChatUserID = ""
            let ChatUserName = ""
            let datamsg = dataa as! [[String:Any]]
            let data = datamsg[0]["msg"] as! [String:Any]
            let attachment = data["attachment"] as? Int ?? 0
            let attachmentType = data["attachmentType"] as? String ?? ""
            let fileURL = data["fileURL"] as? String ?? ""
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
            let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent, senderData: [:], fileURL:fileURL, attachmentType: attachmentType)
            
            self.messages.append(temp)
            
            self.tableView.reloadData()
        }
        
        self.socket.on("chat_history") { (dataa, ack) in
            self.messages.removeAll()
            print(dataa)
            let rows = dataa[0] as! [[String:Any]]
            for ii in rows {
                var ChatUserID = ""
                let ChatUserName = ""
                let attachment = ii["attachment"] as? Int ?? 0
                let attachmentType = ii["attachmentType"] as? String ?? ""
                let fileURL = ii["fileURL"] as? String ?? ""
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
                let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent, senderData: senderData, fileURL:fileURL, attachmentType: attachmentType )
                
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
        
        let new = ["msg" : self.msgTxtView.text ?? "",
                   "chatHeadId" : self.toUser?.chatHeadId ?? "",
                   "userId": self.userid ,
                   "attachment":false] as [String : Any]
        
        self.messages.append(MockMessage.init(text: self.msgTxtView.text ?? "", user: MockUser.init(senderId: self.toUser?.id ?? "", displayName: ""), messageId: "", date: Date(), attachment: 0, createdAt: "", deletedAt: "", id: "", msg: self.msgTxtView.text ?? "", status: 0, toUserID: self.toUser?.id ?? "", updatedAt: "", userID: "", sent: true,senderData: [:], fileURL:"", attachmentType: ""))
        self.msgTxtView.text = ""
        
        self.socket.emit("send", new)
        
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
        if self.messages[indexPath.row].sent {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! msgSenderCell
            let ind = self.messages[indexPath.row]
            cell.view1.cornerRadius(radius: 13)
            cell.txt1.text = ind.msg
            cell.sentimg.image = UIImage.init(named: "sent")
            cell.view1.backgroundColor = UIColor.init(hex: 0x3B5998)
            cell.txt1.textColor = UIColor.white
            cell.txt1.font = UIFont.init(name: APPFont.semibold, size: 16)
            cell.timelbl.text = ind.createdAt
            if ind.attachment == 1{
                if ind.attachmentType == "video"{
                    if !ind.fileURL.isEmpty{
                        if let url = URL(string: ind.fileURL) {
                        cell.img.image = videoPreviewImage(url: url)
                        }
                    }
                }
            }
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
            cell.view1.backgroundColor = UIColor.init(hex: 0x3B5998)
            cell.txt1.textColor = UIColor.init(hex: 0x354052)
            cell.txt1.font = UIFont.init(name: APPFont.semibold, size: 16)
            cell.timelbl.text = ind.createdAt
            if ind.attachment == 1{
                if ind.attachmentType == "video"{
                    if !ind.fileURL.isEmpty{
                        if let url = URL(string: ind.fileURL) {
                        cell.img.image = videoPreviewImage(url: url)
                            //cell.img
                        }
                    }
                }
            }
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
    
    func videoPreviewImage(url: URL) -> UIImage? {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
        
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

extension mainChatVC : AVPlayerViewControllerDelegate {
    func play(url1: String) {
        
//        let path = Bundle.main.path(forResource: "video", ofType: "mp4")!
//
//        let url = NSURL(fileURLWithPath: path)
        guard let urlFromString = URL(string: url1) else { return }

        let player = AVPlayer(url: urlFromString as URL)
        
        playerController = AVPlayerViewController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didfinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        playerController.player = player
        
        playerController.allowsPictureInPicturePlayback = true
        
        playerController.delegate = self
        
        playerController.player?.play()
        
        self.present(playerController, animated: true, completion : nil)
        
        
    }
    
    @objc func didfinishPlaying(note : NSNotification)  {
        
        playerController.dismiss(animated: true, completion: nil)
//        let alertView = UIAlertController(title: "Finished", message: "Video finished", preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alertView, animated: true, completion: nil)
    }
    
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
        let currentviewController = navigationController?.visibleViewController
        
        if currentviewController != playerViewController{
            
            currentviewController?.present(playerViewController, animated: true, completion: nil)
            
        }
        
    }
}

extension mainChatVC{
    
    @objc func attachmentButtonClicked(){
//        openGallery()
        play(url1: "https://www.youtube.com/watch?v=Ot_XnQjhgj8")
    }
    
    func openGallery() {
        let img = UIImagePickerController()
        img.delegate = self
        img.allowsEditing = true
        img.sourceType = .photoLibrary
        
        self.present(img, animated: true, completion: nil)
    }
    func openCamera() {
        let img = UIImagePickerController()
        img.delegate = self
        img.allowsEditing = true
        img.sourceType = .camera
        
        self.present(img, animated: true, completion: nil)
    }
     func uploadImg() {
        self.loadAnimation()
        APIManager.sharedInstance.uploadImage(vc: self, img: self.img.image!) { (str) in
            if str == "success" {
                self.removeAnimation()
                
//                self.performSegue(withIdentifier: "proceed", sender: self)
            }
        }
    }
}
extension mainChatVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
//        self.img.image = img
//        picker.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true) {
            self.uploadImg()
        }
    }
}


