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
    @IBOutlet weak var audioPlayer:UIView!
    @IBOutlet weak var audiaPlayButton:UIButton!
    @IBOutlet weak var audioTimerLabel:UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var isSent:Bool = false
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
    var groupHead: groupHeads?
    var isGroup: Bool?
    var socket:SocketIOClient!
    var playerController : AVPlayerViewController!
    var isScrollToTop: Bool = false
    var offsetObservation: NSKeyValueObservation?
    var isWallpaperOption:Bool = false
    var wallpaperImageView: UIImageView?
            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        self.img.cornerRadius(radius: self.img.frame.height / 2)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.socket =  SocketSessionHandler.manager.defaultSocket

        self.addHandler()
        self.tableView.becomeFirstResponder()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapBtnAction(_:)))
        self.view.addGestureRecognizer(recognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(attachmentButtonClicked), name: Notification.Name.init(rawValue: "attachmentButtonClicked"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.typingLabel.text = ""
        
        if isGroup == true{
            
            APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
                self.userid = user.id
                let neww = ["userId":user.id,"chatHeadId":self.groupHead?.id ?? ""] as [String : Any]
                self.socket.emitWithAck("get_history", neww).timingOut(after: 20) {data in
                    return
                }
            }
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
    }
    
    @IBAction func playAudioButtonAction(_ sender:UIButton) {
       
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
        self.present(multiOptionVC!, animated: true) {
            
        }
    }
    @IBAction func sendmsg(_ sender:UIButton) {
       
        self.msgTxtView.text = ""
        self.view.endEditing(true)
        
    }
    
    func addHandler() {
        
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
            self.isSent = true
            self.scrollToBottom()
            self.getHistorySocketCall(pageNumber: 1)
        }
        
        self.socket.on("sent_ios") { data, ack in
            print(data)
            self.isSent = true
            self.scrollToBottom()
            self.getHistorySocketCall(pageNumber: 1)
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
                if sent {
                    ChatUserID = self.userid
                    
                } else {
                    ChatUserID = self.toUser?.id ?? ""
                }
                let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent, senderData: senderData, fileURL:fileURL, attachmentType: attachmentType, videothumbnail: videothumbnail )
                
                self.lastData.append(temp)
               
            }
            if self.isSent  {
                if self.messages.count > 10{
                    for _ in 0...9 {
                        self.messages.removeLast()
                    }
                }else{
                    self.messages.removeAll()
                }
                self.messages.append(contentsOf: self.lastData)
                self.isSent = false
            }else{
                self.messages.insert(contentsOf: self.lastData, at: 0)
            }
            self.numberOfRecords = self.messages.count
            self.tableView.reloadData {
        
            }
            if !self.isScrollToTop{
            self.scrollToBottom()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0){
            self.loadMore()
            self.isScrollToTop = true
        }
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            self.isScrollToTop = false
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
                    self.isSent = false
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

extension mainChatVC{
    func playAudio(url: String, cell: UITableViewCell) {
        let player = AVPlayer(url: URL(string: url)!)
        player.play()
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main) { time in

            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(player.currentItem!.duration)
            if let cell = cell as? msgSenderCell{
                cell.progressBar.progress = Float(fraction)
            }
            if let cell = cell as? msgSenderCell{
                cell.progressBar.progress = Float(fraction)
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
        if self.messages[indexPath.row].sent {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! msgSenderCell
            cell.selectionStyle = .none
            let ind = self.messages[indexPath.row]
            cell.view1.cornerRadius(radius: 13)
            cell.txt1.text = ind.msg
            cell.sentimg.image = UIImage.init(named: "sent")
            cell.view1.backgroundColor = UIColor.init(hex: 0x3B5998)
            cell.txt1.textColor = UIColor.white
            cell.txt1.font = UIFont.init(name: APPFont.semibold, size: 16)
            cell.timelbl.text = ind.createdAt
            cell.img.image = nil
            cell.playImageView.image = nil
            cell.audioPlayer.isHidden = true
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
                        cell.playImageView.image = UIImage(named: "Play")
//                        addBlurEffectToImageView(imageView: cell.img)
                        cell.img.tag = indexPath.row
                        cell.img.isUserInteractionEnabled = true
                    }
                }else if ind.attachmentType == "Image"{
                    if !ind.fileURL.isEmpty{
                        cell.img.kf.indicatorType = .activity
                        cell.img.kf.setImage(with: URL(string: ind.fileURL))
                        cell.img.tag = indexPath.row
                    }else{
                        cell.img.image = nil
                    }
                }else if ind.attachmentType == "Audio"{
                    if !ind.fileURL.isEmpty{
                        cell.audioPlayer.isHidden = false
                        cell.progressBar.progress = 0.0
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
            cell.audioPlayer.isHidden = true
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
                        cell.playImageView.image = UIImage(named: "Play")
//                        addBlurEffectToImageView(imageView: cell.img)
                        cell.img.tag = indexPath.row
                        cell.img.isUserInteractionEnabled = true
                    }
                }else if ind.attachmentType == "Image"{
                    if !ind.fileURL.isEmpty{
                        cell.img.kf.indicatorType = .activity
                        cell.img.kf.setImage(with: URL(string: ind.fileURL))
                        cell.img.tag = indexPath.row
                    }else{
                        cell.img.image = nil
                    }
                }else if ind.attachmentType == "Audio"{
                    if !ind.fileURL.isEmpty{
                        cell.audioPlayer.isHidden = false
                        cell.txt1.text = "                           "
                        cell.progressBar.progress = 0.0
                    }
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
            }
        }
        
        if isGroup == true{
            let cell = self.tableView.cellForRow(at: indexPath)
            if let cell = cell as? msgReceiverCell{
                return 70
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
    func scrollToBottom(){
        
        if self.messages.count > 0{
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        }
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
    @IBOutlet var playImageView: UIImageView!
    @IBOutlet weak var audioPlayer:UIView!
    @IBOutlet weak var audiaPlayButton:UIButton!
    @IBOutlet weak var audioTimerLabel:UILabel!
    @IBOutlet var audiaPlayButtonImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.audioPlayer.cornerRadius(radius: 13)
        self.audioPlayer.backgroundColor = UIColor.init(hex: 0x3B5998)
    }
}
class msgReceiverCell:UITableViewCell {
    
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatNameView: UIView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var sentimg:UIImageView!
    @IBOutlet weak var timelbl:UILabel!
    @IBOutlet weak var proImg:UIImageView!
    @IBOutlet var playImageView: UIImageView!
    @IBOutlet weak var audioPlayer:UIView!
    @IBOutlet weak var audiaPlayButton:UIButton!
    @IBOutlet weak var audioTimerLabel:UILabel!
    @IBOutlet var audiaPlayButtonImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.audioPlayer.cornerRadius(radius: 13)
        self.audioPlayer.backgroundColor = UIColor.init(hex: 0x3B5998)
        
        
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
    
}

extension mainChatVC: UIGestureRecognizerDelegate{
    @objc func tapBtnAction(_ sender: UITapGestureRecognizer) {
        self.tableView.becomeFirstResponder()
        }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) == true{
            return false
        }else{
            return true
        }
    }
}

extension mainChatVC : AVPlayerViewControllerDelegate {
    
    func videoPlaySelect(indexPath: IndexPath ) {
        print("\(String(describing: indexPath.row)) Tapped")
        let data = self.messages[indexPath.row]
            if data.attachment == 1{
                if data.attachmentType == "Video"{
                    if !data.fileURL.isEmpty{
                        play(url1: data.fileURL)
                    }
                }else if data.attachmentType == "Image"{
                    if !data.fileURL.isEmpty{
                        
                    }
                }else if data.attachmentType == "Audio"{
                    if !data.fileURL.isEmpty{
                        let cell = self.tableView.cellForRow(at: indexPath)
                        playAudio(url: data.fileURL, cell: cell!)
                    }
                }
            }
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
            let data = self?.messages[(self?.selectedCell!.row)!]
            let payload = ["messageId": data?.id, "userId": data?.userID]
            self?.socket.emit("deleteChat", payload)
            //self?.getHistorySocketCall(pageNumber:self!.pageNumberToBeLoad)
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
}
extension mainChatVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
        self.uploadImage = img
        picker.dismiss(animated: true) {
            if self.isWallpaperOption == false{
                self.uploadImg()
            }else{
                self.setImageInBackgroud(image: img)
            }
        }
    }
}

extension mainChatVC{
    
    func addBlurEffectToImageView(imageView: UIImageView){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        imageView.addSubview(blurEffectView)
        imageView.insertSubview(blurEffectView, at: 0)
//        self.blurView = blurEffectView
    }
    
    func removeBlurEffect(imageView: UIImageView){
        self.blurView?.removeFromSuperview()
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
    
    
    func setImageInBackgroud(image: UIImage){
        self.wallpaperImageView = UIImageView(image: image)
        self.wallpaperImageView?.frame = self.backGroundView.bounds
        self.backGroundView.addSubview(self.wallpaperImageView ?? UIImageView())
        self.backGroundView.bringSubviewToFront(self.tableView)
        self.backGroundView.bringSubviewToFront(self.headerView)
        self.tableView.backgroundColor = UIColor.clear
    }
    
    func removeImageFromBackground(){
        self.wallpaperImageView?.removeFromSuperview()
        self.tableView.backgroundColor = UIColor.white
    }
    
    
}

extension mainChatVC: ViewContactVCDeleagte{
    func showWallpaperOptions() {
        openWallpaper()
    }
    
    
}
