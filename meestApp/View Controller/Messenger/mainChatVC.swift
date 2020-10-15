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
import MMPlayerView
import RealmSwift

enum AttachmentType:String {
    case Image = "Image"
    case Video = "Video"
}

class mainChatVC: RootBaseVC {

    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var txtView:UIView!
    @IBOutlet weak var sendBtn:UIButton!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var msgTxtView:UITextView!
    @IBOutlet weak var tableView:chatTblView!
    @IBOutlet var typingLabel: UILabel!
    @IBOutlet weak var settingHeaderButton: UIButton!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    
//    var isSent:Bool = false
    var numberOfRecords = 0
    var pageNumberToBeLoad = 1
    var blurView: UIView?
    var selectedCell: IndexPath?
    var uploadImage: UIImage?
    var userid = ""
    var count = 0
    var toUser:ChatHeads?
    var messages = [MockMessage]()
    var lastData = [MockMessage]()
    var searchCopy = [MockMessage]()
    var groupHead: groupHeads?
    var isGroup: Bool?
    var socket:SocketIOClient!
    var playerController : AVPlayerViewController!
//    var isScrollToTop: Bool = false
    var offsetObservation: NSKeyValueObservation?
    var isWallpaperOption:Bool = false
    var wallpaperImageView: UIImageView?
    var timeCount = 0
    var realmManager = RealmManager()
    var sendImageChange = 0
    var isMediaAutoDowload: Bool = false
    var player: AVPlayer?
    var isVideo: Bool = false
    var videoData = Data()
    var isPlaying: Bool = false
    
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        //l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        self.img.cornerRadius(radius: self.img.frame.height / 2)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.socket =  SocketSessionHandler.manager.defaultSocket
        
        self.addHandler()
        self.searchView.isHidden = true
        self.searchTextField.delegate = self
        self.tableView.becomeFirstResponder()
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapBtnAction(_:)))
//        recognizer.delegate = self
//        self.view.addGestureRecognizer(recognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(attachmentButtonClicked), name: Notification.Name.init(rawValue: "attachmentButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBlockContact), name: Notification.Name.init(rawValue: "blockContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showWallpaper), name: Notification.Name.init(rawValue: "showWallpaper"), object: nil)
        
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
        offsetObservation = tableView.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = self, self.presentedViewController == nil else {return}
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        }
        
//        mmPlayerLayer.getStatusBlock { [weak self] (status) in
//            switch status {
//            case .failed(let err):
//                let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self?.present(alert, animated: true, completion: nil)
//            case .ready:
//                print("Ready to Play")
//            case .playing:
//                print("Playing")
//            case .pause:
//                print("Pause")
//            case .end:
//                print("End")
//            default: break
//            }
//        }
        
    }

    private func getDataFromDB(objects: Results<Object>) {
        for element in objects {
            if let data = element as? Imagedata {
                self.setImageInBackgroud(image: UIImage(data: data.data!)!)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.typingLabel.text = ""
        self.isMediaAutoDowload = UserDefaults.standard.bool(forKey: "Media")
//        guard let info = realm.objects(Info.self).first else {return}
        if let displayContent = realmManager.getObjects(type: Imagedata.self), displayContent.count > 0 {
            // display data
            getDataFromDB(objects: displayContent)
        }
        
        if isGroup == true{
            
            APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
                self.userid = user.id
                let neww = ["userId":user.id,"chatHeadId":self.groupHead?.id ?? ""] as [String : Any]
                self.socket.emitWithAck("get_history", neww).timingOut(after: 20) {data in
                    return
                }
            }
            
            UserDefaults.standard.set(self.userid, forKey: "UserId")
            UserDefaults.standard.set(self.groupHead?.id, forKey: "ChatHeadId")
            self.nameLbl.text = self.groupHead?.groupName
            self.img.applyRoundedView()
            self.img.kf.indicatorType = .activity
            self.img.kf.setImage(with: URL(string: self.groupHead?.groupIcon ?? ""),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")

                case .failure(let error):
                    print(self.groupHead?.groupIcon)
                    print("Job failed: \(error.localizedDescription)")
                }
            }
            
            
        }else{
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            self.userid = user.id
            let neww = ["userId":user.id,"chatHeadId":self.toUser?.chatHeadId ?? ""] as [String : Any]
            self.socket.emitWithAck("get_history", neww).timingOut(after: 20) {data in
                return
            }
        }
            UserDefaults.standard.set(self.userid, forKey: "UserId")
            UserDefaults.standard.set(self.toUser?.chatHeadId, forKey: "ChatHeadId")
        self.nameLbl.text = (self.toUser?.firstName ?? "") + " " + (self.toUser?.lastName ?? "")
        self.img.applyRoundedView()
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
        }
        self.messages.removeAll()
        
        if isGroup == true{
            self.tableView.group = self.groupHead
            self.tableView.isGroup = isGroup
        }else{
            self.tableView.toUser = self.toUser
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.becomeFirstResponder()
        self.longPressGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.messages.removeAll()
        self.lastData.removeAll()
        if player != nil{
            player?.pause()
        }
        if mmPlayerLayer != nil{
            mmPlayerLayer.player?.pause()
        }
    }
    
    @IBAction func settingHeaderButtonAction(_ sender:UIButton) {
       
        self.tableView.becomeFirstResponder()
        
        if isGroup == true{
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let groupSettingVC = stoaryboard.instantiateViewController(withIdentifier: "GroupSeettingViewController") as? GroupSeettingViewController
        groupSettingVC?.modalPresentationStyle = .overCurrentContext
        groupSettingVC?.modalTransitionStyle = .crossDissolve
        groupSettingVC?.groupImage = self.img.image
        groupSettingVC?.groupName = self.nameLbl.text ?? ""
        groupSettingVC?.groupId = groupHead?.id ?? ""
        self.present(groupSettingVC!, animated: true, completion: nil)
        }
        
    }
    @IBAction func searchCloseButtonAction(_ sender: UIButton){
        self.searchView.isHidden = true
        searchCopy = messages
        self.searchTextField.text = ""
        self.searchTextField.resignFirstResponder()
        self.tableView.becomeFirstResponder()
    }
    
    @IBAction func callButtonAction(_ sender:UIButton) {
       
        self.tableView.becomeFirstResponder()
        
    }
    @IBAction func videoCallButtonAction(_ sender:UIButton) {
       
        self.tableView.becomeFirstResponder()
        
    }
    @IBAction func informationButtonAction(_ sender:UIButton) {
        self.tableView.becomeFirstResponder()
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let multiOptionVC = stoaryboard.instantiateViewController(withIdentifier: "MultiOptionVC") as? MultiOptionVC
        multiOptionVC?.modalPresentationStyle = .overCurrentContext
        multiOptionVC?.modalTransitionStyle = .crossDissolve
        multiOptionVC?.allChatMessage = messages
        multiOptionVC?.deleagte = self
        
        if isGroup == true{
            multiOptionVC?.isFromGroup = true
        }else{
            multiOptionVC?.isFromGroup = false
        }
        self.present(multiOptionVC!, animated: true) {
            
        }
        
        multiOptionVC?.searchChatCompletion = {
            self.searchView.isHidden = false
            self.searchTextField.becomeFirstResponder()
        }
    }
    @IBAction func sendmsg(_ sender:UIButton) {
       
        self.msgTxtView.text = ""
        self.view.endEditing(true)
        
    }
    
    func addHandler() {
        
        self.socket.on("read") {data, ack in
            
        }
        
        self.socket.on("deletedMessage") { data, ack in
            print(data)
            if let val = self.selectedCell?.row{
                let data = self.messages[val]
                if data.status == 1 {
                    let cell = self.tableView.cellForRow(at: self.selectedCell!)
                    if let cell = cell as? msgSenderCell{
                        cell.txt1.text = "@This message was deleted."
                        cell.txt1.textColor = UIColor.lightGray
                        cell.txt1.font = UIFont.italicSystemFont(ofSize: 15.0)
                    }else if let cell = cell as? msgReceiverCell{
                        cell.txt1.text = "@This message was deleted."
                        cell.txt1.textColor = UIColor.lightGray
                        cell.txt1.font = UIFont.italicSystemFont(ofSize: 15.0)
                    }
                    self.messages[val].msg = "@This message was deleted"
                    self.messages[val].status = 0
                }
            }
        }

        
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
            var chatID = ""
            if self.isGroup == true{
                chatID = self.groupHead?.id ?? ""
            }else{
                chatID = self.toUser?.chatHeadId ?? ""
            }
            let dataa = ["userId":self.userid,"chatHeadId":chatID]
            self.socket.emit("readMessage", dataa)
            
            let val =  data[0] as? [String:Any] ?? [:]
            let ii =  val["msg"] as? [String:Any] ?? [:]
            let ChatUserID = ""
            let ChatUserName = ""
            let attachment = ii["attachment"] as? Int ?? 0
            let attachmentType = ii["attachmentType"] as? String ?? ""
            let fileURL = ii["fileURL"] as? String ?? ""
            let createdAt = ii["createdAt"] as? String ?? ""
            let deletedAt = ii["deletedAt"] as? String ?? ""
            let id = ii["id"] as? String ?? ""
            let msg = ii["msg"] as? String ?? ""
            let status = ii["status"] as? Int ?? 1
            let toUserId = ii["chatHeadId"] as? String ?? ""
            let updatedAt = ii["updatedAt"] as? String ?? ""
            let userId = ii["userId"] as? String ?? ""
            let sent = ii["sent"] as? Bool ?? false
            let senderData = ii["senderData"] as? [String: Any] ?? [:]
            let videothumbnail = ii["thumbnail"] as? String ?? ""
            let read = ii["read"] as? Int ?? 0
            
             let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent, senderData: senderData, fileURL:fileURL, attachmentType: attachmentType, videothumbnail: videothumbnail, read: read, category: "" )
            self.messages.append(temp)
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            self.numberOfRecords = self.messages.count
        }
        
        self.socket.on("sent_ios") { data, ack in
            print(data)
            var chatID = ""
            if self.isGroup == true{
                chatID = self.groupHead?.id ?? ""
            }else{
                chatID = self.toUser?.chatHeadId ?? ""
            }
            let dataa = ["userId":self.userid,"chatHeadId":chatID]
            self.socket.emit("readMessage", dataa)
//            self.isSent = true
            
            let val =  data[0] as? [String:Any] ?? [:]
            let ii =  val["msg"] as? [String:Any] ?? [:]
            var ChatUserID = ""
            let ChatUserName = ""
            let attachment = ii["attachment"] as? Int ?? 0
            let attachmentType = ii["attachmentType"] as? String ?? ""
            let fileURL = ii["fileURL"] as? String ?? ""
            let createdAt = ii["createdAt"] as? String ?? ""
            let deletedAt = ii["deletedAt"] as? String ?? ""
            let id = ii["id"] as? String ?? ""
            let msg = ii["msg"] as? String ?? ""
            let status = ii["status"] as? Int ?? 1
            let toUserId = ii["chatHeadId"] as? String ?? ""
            let updatedAt = ii["updatedAt"] as? String ?? ""
            let userId = ii["userId"] as? String ?? ""
            let sent = ii["sender"] as? Bool ?? true
            let senderData = ii["senderData"] as? [String: Any] ?? [:]
            let videothumbnail = ii["thumbnail"] as? String ?? ""
            let read = ii["read"] as? Int ?? 0
            
             let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: true, senderData: senderData, fileURL:fileURL, attachmentType: attachmentType, videothumbnail: videothumbnail, read: read, category: "" )
            self.messages.append(temp)
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            self.numberOfRecords = self.messages.count
//            self.searchCopy = self.messages
        }
        
        self.socket.on("chat_history") { (dataa, ack) in
            self.lastData.removeAll()
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
                let toUserId = ii["chatHeadId"] as? String ?? ""
                let updatedAt = ii["updatedAt"] as? String ?? ""
                let userId = ii["userId"] as? String ?? ""
                let sent = ii["sender"] as? Bool ?? false
                let senderData = ii["senderData"] as? [String: Any] ?? [:]
                let videothumbnail = ii["thumbnail"] as? String ?? ""
                let read = ii["read"] as? Int ?? 0
                if sent {
                    ChatUserID = self.userid
                    
                } else {
                    ChatUserID = self.toUser?.id ?? ""
                }
                let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent, senderData: senderData, fileURL:fileURL, attachmentType: attachmentType, videothumbnail: videothumbnail, read: read, category: "" )
                
                self.lastData.append(temp)
               
            }
            self.messages.insert(contentsOf: self.lastData, at: 0)
            self.numberOfRecords = self.messages.count
            self.tableView.reloadData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0){
            self.loadMore()
        }
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
        }
    }
    
    func getHistorySocketCall(pageNumber: Int){
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            self.userid = user.id
            var chatID: String?
            if self.isGroup == true{
                chatID = self.groupHead?.id ?? ""
            }else{
                chatID = self.toUser?.chatHeadId ?? ""
            }
            let neww = ["userId":user.id,"chatHeadId":chatID ?? "","page":pageNumber] as [String : Any]
            self.socket.emit("get_history", neww)
        }

    }
  
    func loadMore(){
        if messages.count != 0{
            if numberOfRecords / messages.count >= 1 {
                pageNumberToBeLoad += 1
                APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
                    self.userid = user.id
                    var chatID: String?
                    if self.isGroup == true{
                        chatID = self.groupHead?.id ?? ""
                    }else{
                        chatID = self.toUser?.chatHeadId ?? ""
                    }
                    let neww = ["userId":user.id,"chatHeadId":chatID ?? "","page":self.pageNumberToBeLoad] as [String : Any]
//                    self.isSent = false
                    self.socket.emit("get_history", neww)
                }
            }
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
}

extension mainChatVC: AVAudioPlayerDelegate{
    func playAudio(url: String, cell: UITableViewCell) {
        self.timeCount = 0
        player = AVPlayer(url: URL(string: url)!)
        player?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main) { time in
                
            let fraction = CMTimeGetSeconds(time)  / CMTimeGetSeconds((self.player?.currentItem!.duration)!)
            if let cell = cell as? AudioMsgSenderCell{
                cell.progressBar.layoutIfNeeded()
                DispatchQueue.main.async {
                    cell.progressBar.progress = Float(fraction)
                    print(Float(fraction), time, self.player?.currentItem?.duration)
                    self.timeCount += 1
                    cell.audioTimerLabel.text = String(format: "%02d:%02d",(self.timeCount/60)%60,self.timeCount%60)
                }
            }
            if let cell = cell as? AudioMsgReceiverCell{
                cell.progressBar.layoutIfNeeded()
                cell.progressBar.progress = Float(fraction)
                self.timeCount += 1
                cell.audioTimerLabel.text = String(format: "%02d:%02d",(self.timeCount/60)%60,self.timeCount%60)
            }
        }
    }
    
    @objc
    func didPlayToEnd(){
        let cell = self.tableView.cellForRow(at: selectedCell ?? [0,0])
        
        if let cell = cell as? AudioMsgSenderCell{
            cell.progressBar.layoutIfNeeded()
            DispatchQueue.main.async {
                cell.progressBar.progress = Float(1.0)
            }
        }
        if let cell = cell as? AudioMsgReceiverCell{
            cell.progressBar.layoutIfNeeded()
            DispatchQueue.main.async {
                cell.progressBar.progress = Float(1.0)
            }
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

extension UITableView {
func reloadData(completion:@escaping ()->()) {
    UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
}
}

extension mainChatVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.messages[indexPath.row].sent && self.messages[indexPath.row].attachment == 1 && self.messages[indexPath.row].attachmentType == "Audio"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! AudioMsgSenderCell
            if !self.messages[indexPath.row].fileURL.isEmpty{
                cell.progressBar.progress = 0.0
            }
            if toUser?.isOnline == true{
                if self.messages[indexPath.row].read == 1{
                    cell.sentimg.image = UIImage.init(named: "ReadChat")
                }else{
                    cell.sentimg.image = UIImage.init(named: "sent")
                }
            }else{
                cell.sentimg.image = UIImage.init(named: "SingleTick")
            }
            cell.timelbl.text = self.messages[indexPath.row].createdAt
            return cell
            
        }else if self.messages[indexPath.row].sent == false && self.messages[indexPath.row].attachment == 1 && self.messages[indexPath.row].attachmentType == "Audio"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! AudioMsgReceiverCell
            if !self.messages[indexPath.row].fileURL.isEmpty{
                cell.progressBar.progress = 0.0
            }
            cell.timelbl.text = self.messages[indexPath.row].createdAt
            cell.sentimg.image = UIImage.init(named: "Recievechat")
            if isGroup == true{
                cell.chatNameView.isHidden = false
//                cell.chatNameView.cornerRadius(radius: 13)
                cell.chatNameView.backgroundColor = UIColor.init(hex: 0xE0F3FF )
                cell.chatUserName.textColor = UIColor.init(hex: 0x3B5998)
                cell.chatUserName.font = UIFont.init(name: APPFont.regular, size: 10)
               cell.chatNameView.roundCorners(corners: [.topLeft, .topRight], radius: 13.0)
                cell.view1.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 13.0)
            }else{
                cell.chatNameView.isHidden = true
                cell.view1.cornerRadius(radius: 13)
            }
            if let url = self.messages[indexPath.row].senderData["displayPicture"] as? String{
                cell.proImg.applyRoundedView()
            cell.proImg.image = UIImage(named: "img")
            cell.proImg.kf.indicatorType = .activity
            cell.proImg.kf.setImage(with: URL(string: url))
            }else{
                cell.proImg.image = nil
            }
            
            return cell
            
        }else if self.messages[indexPath.row].sent {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! msgSenderCell
            cell.selectionStyle = .none
            cell.delegate = self
            let ind = self.messages[indexPath.row]
            cell.view1.cornerRadius(radius: 13)
            cell.txt1.text = ind.msg
            if toUser?.isOnline == true{
                if ind.read == 1{
                    cell.sentimg.image = UIImage.init(named: "ReadChat")
                }else{
                    cell.sentimg.image = UIImage.init(named: "sent")
                }
            }else{
                cell.sentimg.image = UIImage.init(named: "SingleTick")
            }
            cell.view1.backgroundColor = UIColor.init(hex: 0x3B5998)
            cell.txt1.textColor = UIColor.white
            cell.txt1.font = UIFont.init(name: APPFont.semibold, size: 16)
            cell.timelbl.text = ind.createdAt
            cell.img.image = nil
            cell.playImageView.image = nil
            cell.downloadBackGroundi.backgroundColor = .clear
            if ind.status == 0{
                cell.txt1.text = "@This message was deleted."
                cell.txt1.textColor = UIColor.lightGray
                cell.txt1.font = UIFont.italicSystemFont(ofSize: 15.0)
            }
            if ind.attachment == 1{
                cell.txt1.text = ""
                if ind.attachmentType == "Video"{
                    if !ind.videothumbnail.isEmpty{
                        cell.img.kf.indicatorType = .activity
                        cell.img.kf.setImage(with: URL(string: ind.videothumbnail))
//                        cell.downloadBackGroundi.backgroundColor = UIColor.init(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.6)
//                        cell.playImageView.image = UIImage(named: "Play")
                        cell.img.tag = indexPath.row
                        cell.img.isUserInteractionEnabled = true
                        mmPlayerLayer.thumbImageView.image = cell.img.image
                        mmPlayerLayer.playView = cell.img
                        if !ind.fileURL.isEmpty{
                            mmPlayerLayer.set(url: URL(string: ind.fileURL))
                            mmPlayerLayer.resume()
                        }
                    }
                }else if ind.attachmentType == "Image"{
                    if !ind.fileURL.isEmpty{
                        cell.img.kf.indicatorType = .activity
                        
                        if self.isMediaAutoDowload == true{
                            cell.img.kf.setImage(with: URL(string: ind.fileURL))
                        }else{
                            cell.img.kf.setImage(with: URL(string: ind.fileURL))
                        }
                        cell.img.tag = indexPath.row
                    }else{
                        cell.img.image = nil
                    }
                }

            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! msgReceiverCell
            cell.selectionStyle = .none
            if isGroup == true{
                cell.chatNameView.isHidden = false
//                cell.chatNameView.cornerRadius(radius: 13)
                cell.chatNameView.backgroundColor = UIColor.init(hex: 0xE0F3FF )
                cell.chatNameLabel.textColor = UIColor.init(hex: 0x3B5998)
                cell.chatNameLabel.font = UIFont.init(name: APPFont.regular, size: 10)
               cell.chatNameView.roundCorners(corners: [.topLeft, .topRight], radius: 13.0)
                cell.view1.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 13.0)
            }else{
                cell.chatNameView.isHidden = true
                cell.view1.cornerRadius(radius: 13)
            }
            let ind = self.messages[indexPath.row]
            cell.chatNameLabel.text = ind.senderData["username"] as? String ?? ""
            cell.txt1.text = ind.msg
            cell.view1.backgroundColor = UIColor.init(hex: 0xECF7FE)
            cell.txt1.textColor = UIColor.init(hex: 0x354052)
            cell.txt1.font = UIFont.init(name: APPFont.semibold, size: 16)
            cell.timelbl.text = ind.createdAt
            cell.img.image = nil
            cell.playImageView.image = nil
            cell.downloadBackGroundi.backgroundColor = .clear
            cell.sentimg.image = UIImage.init(named: "Recievechat")
            if ind.status == 0{
                cell.txt1.text = "@This message was deleted."
                cell.txt1.textColor = UIColor.lightGray
                cell.txt1.font = UIFont.italicSystemFont(ofSize: 15.0)
            }
            if ind.attachment == 1{
                cell.txt1.text = ""
                if ind.attachmentType == "Video"{
                    if !ind.videothumbnail.isEmpty{
                        cell.img.kf.indicatorType = .activity
                        cell.img.kf.setImage(with: URL(string: ind.videothumbnail))
//                        cell.downloadBackGroundi.backgroundColor = UIColor.init(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.6)
//                        cell.playImageView.image = UIImage(named: "Play")
                        cell.img.tag = indexPath.row
                        cell.img.isUserInteractionEnabled = true
                        mmPlayerLayer.thumbImageView.image = cell.img.image
                        mmPlayerLayer.playView = cell.img
                        if !ind.fileURL.isEmpty{
                            mmPlayerLayer.set(url: URL(string: ind.fileURL))
                            mmPlayerLayer.resume()
                        }
                    }
                }else if ind.attachmentType == "Image"{
                    if !ind.fileURL.isEmpty{
                        cell.img.kf.indicatorType = .activity
                        if self.isMediaAutoDowload == true{
                            cell.img.kf.setImage(with: URL(string: ind.fileURL))
                        }else{
                            cell.img.kf.setImage(with: URL(string: ind.fileURL))
                        }
                        cell.img.tag = indexPath.row
                    }else{
                        cell.img.image = nil
                    }
                }else if ind.attachmentType == "Audio"{
                    
                }
            }
            if let url = ind.senderData["displayPicture"] as? String{
                cell.proImg.applyRoundedView()
            cell.proImg.image = UIImage(named: "img")
            cell.proImg.kf.indicatorType = .activity
            cell.proImg.kf.setImage(with: URL(string: url))
            }else{
                cell.proImg.image = nil
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.messages.count > 0, self.messages[indexPath.row].attachment == 1{
            if self.messages[indexPath.row].attachmentType != "Audio"{
                return 250
            }else{
                return 85
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.videoPlaySelect(indexPath: indexPath)
        
        self.selectedCell = indexPath
        tableView.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.showShrinkView(indexPath: indexPath)
    }
    
    func scrollToBottom(){
        
        if self.messages.count > 0{
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        }
    }
    
    func showShrinkView(indexPath: IndexPath ){
        self.mmPlayerLayer.shrinkView(onVC: self, isHiddenVC: false) { [weak self] () -> UIView? in
            guard let self = self else {return nil}
            let data = self.messages[indexPath.row]
            let cell = self.tableView.cellForRow(at: indexPath)
            if let cell = cell as? msgReceiverCell{
                
                self.mmPlayerLayer.set(url: URL(string: data.fileURL))
                self.mmPlayerLayer.resume()
                return cell.img
            }
            if let cell = cell as? msgSenderCell{
                self.mmPlayerLayer.set(url: URL(string: data.fileURL))
                self.mmPlayerLayer.resume()
                return cell.img
            }
            return UIView()
            
        }

    }
}

class AudioMsgReceiverCell: UITableViewCell {
    @IBOutlet weak var audioPlayer:UIView!
    @IBOutlet weak var audiaPlayButton:UIButton!
    @IBOutlet weak var audioTimerLabel:UILabel!
    @IBOutlet var audiaPlayButtonImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var chatUserName: UILabel!
    @IBOutlet weak var chatNameView:UIView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var proImg:UIImageView!
    @IBOutlet weak var sentimg:UIImageView!
    @IBOutlet weak var timelbl:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.audioPlayer.cornerRadius(radius: 13)
        self.audioPlayer.backgroundColor = UIColor.init(hex: 0x3B5998)
    }
}

class AudioMsgSenderCell: UITableViewCell {
    @IBOutlet weak var audioPlayer:UIView!
    @IBOutlet weak var audiaPlayButton:UIButton!
    @IBOutlet weak var audioTimerLabel:UILabel!
    @IBOutlet var audiaPlayButtonImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var sentimg:UIImageView!
    @IBOutlet weak var timelbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.audioPlayer.cornerRadius(radius: 13)
        self.audioPlayer.backgroundColor = UIColor.init(hex: 0x3B5998)
    }
}


extension mainChatVC: MsgSenderDelegate{
    func playAudiosender(cell: msgSenderCell) {
        
    }
}

protocol MsgSenderDelegate {
    func playAudiosender(cell: msgSenderCell)
}
class msgSenderCell:UITableViewCell {
    
    @IBOutlet weak var downloadBackGroundi:UIView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var sentimg:UIImageView!
    @IBOutlet weak var timelbl:UILabel!
    @IBOutlet var playImageView: UIImageView!

    var delegate: MsgSenderDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    @IBAction func playAudioAction(_ sender:UIButton) {
        delegate?.playAudiosender(cell: self)
    }
}
class msgReceiverCell:UITableViewCell {
    
    @IBOutlet weak var downloadBackGroundi:UIView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatNameView: UIView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var sentimg:UIImageView!
    @IBOutlet weak var timelbl:UILabel!
    @IBOutlet weak var proImg:UIImageView!
    @IBOutlet var playImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
    }
    
    @IBAction func playAudioAction(_ sender:UIButton) {
       
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
            self.chatNameView.roundCorners(corners: [.topLeft, .topRight], radius: 13.0)
            self.view1.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 13.0)
    }
    
}

extension mainChatVC: UIGestureRecognizerDelegate{
//    @objc func tapBtnAction(_ sender: UITapGestureRecognizer) {
//        self.tableView.becomeFirstResponder()
//        }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if touch.view?.isDescendant(of: self.tableView) == true{
//            return false
//        }else{
//            return true
//        }
//    }
}

extension mainChatVC : AVPlayerViewControllerDelegate {
    
    func videoPlaySelect(indexPath: IndexPath ) {
        print("\(String(describing: indexPath.row)) Tapped")
        let data = self.messages[indexPath.row]
            if data.attachment == 1{
                if data.attachmentType == "Video"{
                    if !data.fileURL.isEmpty{
                        if isPlaying == true{
                            self.mmPlayerLayer.player?.play()
                            self.isPlaying = false
                        }else{
                            self.isPlaying = true
                            mmPlayerLayer.player?.pause()
                        }
                    }
                   let status =  mmPlayerLayer.player?.status
                    print(status)
                }else if data.attachmentType == "Image"{
                    if !data.fileURL.isEmpty{
                        let cell = self.tableView.cellForRow(at: indexPath)
                        if let cell = cell as? msgReceiverCell{
                            self.showImageToImageView(image: cell.img.image ?? UIImage())
                            cell.downloadBackGroundi.backgroundColor = .clear
                            cell.playImageView.image = nil
                        }
                        if let cell = cell as? msgSenderCell{
                            self.showImageToImageView(image: cell.img.image ?? UIImage())
                            cell.downloadBackGroundi.backgroundColor = .clear
                            cell.playImageView.image = nil
                        }

                        }
                    
                }
//                else if data.attachmentType == "Audio"{
//                    if !data.fileURL.isEmpty{
//                        let cell = self.tableView.cellForRow(at: indexPath)
//                        playAudio(url: data.fileURL, cell: cell!)
//                    }
//                }
            }
        }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func play(url1: String) {
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
    }
    
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
        let currentviewController = navigationController?.visibleViewController
        
        if currentviewController != playerViewController{
            
            currentviewController?.present(playerViewController, animated: true, completion: nil)
            
        }
        
    }
}

extension mainChatVC{
    
    func messageLongPressAction(){
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let deleteOptionVC = stoaryboard.instantiateViewController(withIdentifier: "DeleteOptionVC") as? DeleteOptionVC
        deleteOptionVC?.modalPresentationStyle = .overCurrentContext
        deleteOptionVC?.modalTransitionStyle = .crossDissolve
        self.present(deleteOptionVC!, animated: true) {
            
        }
        
        deleteOptionVC?.deleteCompletion = { [weak self] in
            print("Delete Called")
            
            let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
            let deleteEveryoneVC = stoaryboard.instantiateViewController(withIdentifier: "DeleteOptionForEveryOneVC") as? DeleteOptionForEveryOneVC
            deleteEveryoneVC?.modalPresentationStyle = .overCurrentContext
            deleteEveryoneVC?.modalTransitionStyle = .crossDissolve
            self?.present(deleteEveryoneVC!, animated: true, completion: nil)
            
            deleteEveryoneVC?.deleteForEveryOneCompletion = {
                let data = self?.messages[(self?.selectedCell!.row)!]
                let payload = ["messageId": data?.id, "userId": data?.userID]
                self?.socket.emit("deleteChat", payload)
            }
            
            deleteEveryoneVC?.deletedCompletion = {
                let data = self?.messages[(self?.selectedCell!.row)!]
                let payload = ["messageId": data?.id, "userId": data?.userID]
                self?.socket.emit("deleteChat", payload)
            }
        }
        
        deleteOptionVC?.replyCompletion = { [weak self] in
            print("Reply Called")
        }
        
        deleteOptionVC?.copyCompletion = { [weak self] in
           
            let data = self?.messages[(self?.selectedCell!.row)!]
            UIPasteboard.general.string = data?.msg
            print("Copy Called \(String(describing: data?.msg))")
        }
    }
    
    @objc func attachmentButtonClicked(){
        let stoaryboard = UIStoryboard(name: "Main", bundle: nil)
        let attachmentVC = stoaryboard.instantiateViewController(withIdentifier: "AttachmentVC") as? AttachmentVC
        attachmentVC?.modalPresentationStyle = .overCurrentContext
        attachmentVC?.modalTransitionStyle = .crossDissolve
        self.present(attachmentVC!, animated: true) {
            
        }
        
        attachmentVC?.openGalleryCompletion = { [weak self] in
            self?.isWallpaperOption = false
            self?.openGallery()
        }
        
        attachmentVC?.openAttachmnetCompletion = { [weak self] in
            self?.openCamera()
        }
    }
        
        @objc func showBlockContact(){
            let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
            let multiOptionVC = stoaryboard.instantiateViewController(withIdentifier: "DeleteChatHeadOptionVC") as? DeleteChatHeadOptionVC
            multiOptionVC?.modalPresentationStyle = .overCurrentContext
            multiOptionVC?.modalTransitionStyle = .crossDissolve
            multiOptionVC?.isBlock = true
            self.present(multiOptionVC!, animated: true) {
                
            }
            multiOptionVC?.deleteCompletion = {
                print("Delete API Called")
            }
        }
    
    @objc func showWallpaper(){
        
        self.openWallpaper()
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
        APIManager.sharedInstance.uploadImage(vc: self, img: (self.uploadImage)!) { (str) in
            if str == "success" {
                self.removeAnimation()
                let imgURL = UserDefaults.standard.string(forKey: "IMG")
                var chatID: String?
                if self.isGroup == true{
                    chatID = self.groupHead?.id ?? ""
                }else{
                    chatID = self.toUser?.chatHeadId ?? ""
                }
                let new = ["msg" : "",
                           "chatHeadId" : chatID ?? "",
                           "userId": self.userid ,
                           "attachment":true,"attachmentType":"Image","fileURL":imgURL ?? ""] as [String : Any]
                print(new)
                self.socket.emit("send", new)
            }else{
                let act = UIAlertController.init(title: "Error", message: "Error in uploading image", preferredStyle: .alert)
                act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                    
                }))
                self.present(act, animated: true, completion: nil)
            }
        }
    }
    
    func uploadVideo(data: Data) {
       self.loadAnimation()
        APIManager.sharedInstance.uploadVideo(vc: self, data: data) { (str) in
           if str == "success" {
               self.removeAnimation()
               let videoURL = UserDefaults.standard.string(forKey: "VIDEO")
            let thumbnail = UserDefaults.standard.string(forKey: "THUMB")
               var chatID: String?
               if self.isGroup == true{
                   chatID = self.groupHead?.id ?? ""
               }else{
                   chatID = self.toUser?.chatHeadId ?? ""
               }
               let new = ["msg" : "",
                          "chatHeadId" : chatID ?? "",
                          "userId": self.userid ,
                          "attachment":true,"attachmentType":"Video","fileURL":videoURL ?? "", "thumbnail":thumbnail] as [String : Any]
               print(new)
               self.socket.emit("send", new)
           }else{
               let act = UIAlertController.init(title: "Error", message: "Error in uploading image", preferredStyle: .alert)
               act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                   
               }))
               self.present(act, animated: true, completion: nil)
           }
       }
   }
}
extension mainChatVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.editedImage] as? UIImage{
            self.uploadImage = img
            self.isVideo = false
        }
        
        if let videoURL = info[.mediaURL] as? URL {
            let video = try? Data(contentsOf: videoURL)
            print("File size before compression: \(Double(video!.count / 1048576)) mb")
            let compressedURL = URL.init(fileURLWithPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")
            compressVideo(inputURL: videoURL , outputURL: compressedURL) { (exportSession) in
                            guard let session = exportSession else {
                                return
                            }
                            switch session.status {
                            case .unknown:
                                break
                            case .waiting:
                                break
                            case .exporting:
                                break
                            case .completed:
                                guard let compressedData = try? Data(contentsOf: compressedURL) else {
                                    return
                                }
                                self.videoData = compressedData
                               print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                            case .failed:
                                break
                            case .cancelled:
                                break
                            @unknown default:
                                print("Fatal Error")
                            }
                        }
            self.isVideo = true
            }
        
        picker.dismiss(animated: true) {
            if self.isWallpaperOption == false{
                if self.isVideo == true{
                    self.uploadVideo(data: self.videoData)
                }else{
                    self.uploadImg()
                }
            }else{
                self.saveImage(image: self.uploadImage ?? UIImage())
            }
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

extension UIImageView{
    func applyRoundedView(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

extension String {
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decode() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}

extension mainChatVC{
    
    func longPressGesture() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        longGesture.minimumPressDuration = 1.0
        
        tableView.addGestureRecognizer(longGesture)
    }
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            let touchPoint = sender.location(in: self.tableView)
                    if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                        self.selectedCell = indexPath
                        self.messageLongPressAction()
                    }
        }
    }
}

extension mainChatVC: MultiOptionVCDelegate{
    func clearChatCompleted() {
        self.messages.removeAll()
        self.tableView.reloadData()
    }
    
    func showWallpaperOption() {
        openWallpaper()
    }
    
    func openWallpaper(){
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let multiOptionVC = stoaryboard.instantiateViewController(withIdentifier: "WallpaperOptionVC") as? WallpaperOptionVC
        multiOptionVC?.modalPresentationStyle = .overCurrentContext
        multiOptionVC?.modalTransitionStyle = .crossDissolve
        self.present(multiOptionVC!, animated: true) {
            
        }
        
        multiOptionVC?.openGalleryCompletion = {
            self.isWallpaperOption = true
            self.openGallery()
        }
        
        multiOptionVC?.noWallpaerCompletion = {
            self.removeImageFromBackground()
        }
    }
    
    func saveImage(image: UIImage){
        let imageData = Imagedata()
        imageData.data = image.pngData()
        RealmManager().saveObjects(objs: imageData)
        self.setImageInBackgroud(image: image)
    }
    
    func setImageInBackgroud(image: UIImage){
        self.wallpaperImageView = UIImageView(image: image)
        self.wallpaperImageView?.frame = self.backGroundView.bounds
        self.backGroundView.addSubview(self.wallpaperImageView ?? UIImageView())
        self.backGroundView.bringSubviewToFront(self.tableView)
        self.backGroundView.bringSubviewToFront(self.headerView)
        self.tableView.backgroundColor = UIColor.clear
    }
    
    func removeImageFromDB(){
        realmManager.deleteDatabase()
    }
    
    func removeImageFromBackground(){
        self.wallpaperImageView?.removeFromSuperview()
        self.tableView.backgroundColor = UIColor.white
        self.removeImageFromDB()
    }
    
    func showImageToImageView(image: UIImage){
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let imageVC = stoaryboard.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController
        imageVC?.modalPresentationStyle = .overCurrentContext
        imageVC?.modalTransitionStyle = .crossDissolve
        imageVC?.imageToShow = image
        self.present(imageVC!, animated: true, completion: nil)
    }
    
}

extension mainChatVC: ViewContactVCDeleagte{
    func showWallpaperOptions() {
        openWallpaper()
    }
}

extension mainChatVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(range)
        if range.location > 0{
            self.search(text: self.searchTextField.text ?? "")

        }else{
            self.search(text: "")
        }
        return true
    }
    
    func search(text: String){
        print(text)
        
        guard !text.isEmpty else {
            searchCopy = messages
            tableView.reloadData()
            return
        }
        
        searchCopy =  messages.filter({ (message) -> Bool in
            message.msg.lowercased().contains(text.lowercased())
        })
        self.tableView.reloadData()
    }

}
